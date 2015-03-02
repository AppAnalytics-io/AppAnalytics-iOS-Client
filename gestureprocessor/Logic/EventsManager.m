#import "EventsManager.h"
#import "GTConstants.h"
#import "Event.h"
#import "Logger.h"
#import "NSUserDefaults+SaveCustomObject.h"
#import "ManifestBuilder.h"
#import "ConnectionManager.h"
#import "AppAnalytics.h"
#import "AFNetworkReachabilityManager.h"

static dispatch_queue_t events_processing_queue()
{
    static dispatch_queue_t events_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        events_queue = dispatch_queue_create("com.app-analytics.events.processing", NULL);
    });
    
    return events_queue;
}

@interface AppAnalytics (EventsManager)

+ (instancetype)instance;
@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSUUID* sessionUUID;
@property (nonatomic, strong) NSString* udid;

@end

@interface EventsManager () 

@property (atomic, readwrite, strong) NSMutableDictionary* events; // { sessionID : mutable array of events }
@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) NSTimeInterval dispatchInterval;
@property (nonatomic, readwrite) BOOL debugLogEnabled;
@property (nonatomic, readwrite) BOOL exceptionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL transactionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL screenAnalyticEnabled;
@property (nonatomic, strong) NSTimer* serializationTimer;
@property (nonatomic, strong) NSTimer* dispatchTimer;

@end

static NSString* const kEventsSerializationKey = @"vKSN9lFJ4d";

@implementation EventsManager

@synthesize events = _events;

+ (instancetype)instance
{
    static EventsManager* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[EventsManager alloc] init];
    });
    return _self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.debugLogEnabled = kDebugLogEnabled;
        self.dispatchInterval = kDefaultEventsDispatchTime;
        self.exceptionAnalyticEnabled = kExceptionAnalyticsEnabled;
        self.transactionAnalyticEnabled = kTransactionAnalyticsEnabled;
        self.screenAnalyticEnabled = kScreenAnalyticsEnabled;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [self scheduleTimers];
    }
    return self;
}

- (void)dealloc
{
    [self.serializationTimer invalidate];
    [self.dispatchTimer invalidate];
    self.events = nil;
}

- (NSMutableDictionary*)events
{
    @synchronized(self)
    {
        if (!_events)
        {
            _events = [NSMutableDictionary dictionary];
            _events[[AppAnalytics instance].sessionUUID.UUIDString] = [NSMutableArray array];
        }
        return _events;
    }
}

- (void)setEvents:(NSMutableDictionary *)events
{
    @synchronized(self)
    {
        _events = events;
    }
}

- (void)setDispatchInterval:(NSTimeInterval)dispatchInterval
{
    _dispatchInterval = MIN(dispatchInterval, kMaxEventsDispatchTime);
    _dispatchInterval = MAX(dispatchInterval, kMinEventsDispatchTime);
    [self refreshDispatchTimer];
}

- (void)scheduleTimers
{
    self.serializationTimer = [NSTimer
                               scheduledTimerWithTimeInterval:kEventsSerializationInterval
                               target:self
                               selector:@selector(serialize)
                               userInfo:nil
                               repeats:YES];
    [self refreshDispatchTimer];
}

- (void)refreshDispatchTimer
{
    if (self.dispatchTimer)
        [self.dispatchTimer invalidate];
    
    self.dispatchTimer = [NSTimer
                          scheduledTimerWithTimeInterval:self.dispatchInterval
                          target:self
                          selector:@selector(sendData)
                          userInfo:nil
                          repeats:YES];
}

- (void)addEvent:(NSString *)description
{
    [self addEvent:description parameters:nil];
}

- (void)addEvent:(NSString *)aDescription parameters:(NSDictionary *)aParameters
{
    __block NSString* description = aDescription;
    __block NSDictionary* parameters = aParameters;
    dispatch_async(events_processing_queue(), ^
    {
        if (description.length > kEventDescriptionMaxLength)
        {
            description = [description substringToIndex:kEventDescriptionMaxLength];
        }
        Event* event = [Event eventWithIndex:self.index++
                                   timestamp:[NSDate new].timeIntervalSince1970
                                 description:description
                                  parameters:parameters];
        
        if (event)
        {
            NSMutableArray* sessionEvents = self.events[[AppAnalytics instance].sessionUUID.UUIDString];
            if (!sessionEvents)
            {
                sessionEvents = [NSMutableArray array];
            }
            NSUInteger index = [sessionEvents indexOfObject:event];
            if (index == NSNotFound || !self.events)
            {
                [sessionEvents addObject:event];
                if (self.debugLogEnabled)
                {
                    [[Logger instance] debugLogEvent:event];
                }
            }
            else
            {
                Event* existingEvent = sessionEvents[index];
                [existingEvent addTimestamp:[event.timestamps.lastObject doubleValue]];
                [existingEvent addIndex:[event.indices.lastObject unsignedIntegerValue]];
                if (self.debugLogEnabled)
                {
                    [[Logger instance] debugLogEvent:existingEvent];
                }
            }
            self.events[[AppAnalytics instance].sessionUUID.UUIDString] = sessionEvents;
        }
    });
}

- (void)sendData
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        return;
    }
    
    dispatch_async(events_processing_queue(), ^
    {
        @autoreleasepool
        {
            for (NSString* sessionID in self.events.allKeys)
            {
                NSMutableArray* wholeSessionPackage = [NSMutableArray array];
                NSMutableArray* sessionChunkEvents = [NSMutableArray array];
                
                int eventInChunkIndex = 0;
                int index = 0;

                for (Event* event in self.events[sessionID])
                {
                    NSDictionary* eventJSONDict = [[ManifestBuilder instance] buildEventJSONDict:event];
                    eventInChunkIndex++;
                    if (eventInChunkIndex > kEventsMaxSizeInBytes / kEventAverageSizeInBytes)
                    {
                        [wholeSessionPackage addObject:sessionChunkEvents];
                        sessionChunkEvents = [NSMutableArray array];
                        eventInChunkIndex = 0;
                    }
                    index++;
                    [sessionChunkEvents addObject:eventJSONDict];
                }
                [wholeSessionPackage addObject:sessionChunkEvents];
                
                for (NSMutableArray* tempSessionChunkEvents in wholeSessionPackage)
                {
                    [[ConnectionManager instance] PUTevents:tempSessionChunkEvents
                                                  sessionID:sessionID
                                                    success:^
                    {
                        [self cleanupUploadedEvents:sessionID eventsNumber:index];
                    }
                                                    failure:^
                    {
                        
                    }];
                }
                wholeSessionPackage = nil;
            }
        }
    });
}

- (void)cleanupUploadedEvents:(NSString*)sessionID eventsNumber:(int)uploadedEventsNumber
{
    if (!sessionID || !uploadedEventsNumber)
    {
        return;
    }
    
    dispatch_async(events_processing_queue(), ^
    {
        NSMutableArray* allSessionEvents = self.events[sessionID];
        NSRange cleanupRange = NSMakeRange(0, MIN(uploadedEventsNumber, allSessionEvents.count));
        if (cleanupRange.length == allSessionEvents.count)
        {
            [self.events removeObjectForKey:sessionID];
        }
        else
        {
            [allSessionEvents removeObjectsInRange:cleanupRange];
            self.events[sessionID] = allSessionEvents;
        }
        allSessionEvents = nil;
        [self serialize];
    });
}

- (void)handleUncaughtException:(NSException *)exception
{
    if (self.exceptionAnalyticEnabled)
    {
        [self addEvent:kUncaughtExceptionEvent parameters:@{kUncaughtExceptionEventReason : exception.reason}];
    }
}

- (void)serialize
{
    dispatch_async(events_processing_queue(), ^
    {
        [[NSUserDefaults standardUserDefaults] saveCustomObject:self.events key:kEventsSerializationKey];
    });
}

- (void)deserialize
{
    self.events = [[NSUserDefaults standardUserDefaults] loadCustomObjectWithKey:kEventsSerializationKey];
    if (!self.events)
    {
        self.events = [NSMutableDictionary dictionary];
        self.events[[AppAnalytics instance].sessionUUID.UUIDString] = [NSMutableArray array];
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    if (!self.transactionAnalyticEnabled)
    {
        return;
    }
    
    for (SKPaymentTransaction * transaction in transactions)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        parameters[kTransactionEventId] = transaction.payment.productIdentifier;
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                parameters[kTransactionEventType] = kTransactionStatePurchasing;
                break;
            case SKPaymentTransactionStatePurchased:
                parameters[kTransactionEventType] = kTransactionStateSucceeded;
                break;
            case SKPaymentTransactionStateFailed:
                parameters[kTransactionEventType] = kTransactionStateFailed;
                break;
            case SKPaymentTransactionStateRestored:
                parameters[kTransactionEventType] = kTransactionStateRestored;
                break;
            case SKPaymentTransactionStateDeferred:
                parameters[kTransactionEventType] = kTransactionStateDeferred;
                break;
            default:
                break;
        }
        
        [self addEvent:kTransactionEvent parameters:parameters.copy];
    }
}

@end
