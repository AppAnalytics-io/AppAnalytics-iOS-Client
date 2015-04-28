#import "AALogger.h"
#import "AAGestureDetails.h"
#import "AAShakeDetails.h"
#import "AANavigationDetails.h"
#import "AAManifestBuilder.h"
#import "AppAnalytics.h"
#import "GTConstants.h"
#import "AAConnectionManager.h"
#import "AAEvent.h"

@import SystemConfiguration;
@import MobileCoreServices;

@interface AAGestureDetails (Tracking)

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;

@end

@interface AAShakeDetails (Tracking)

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;

@end

@interface AppAnalytics (Logger)

+ (instancetype)instance;
+ (void)checkInitialization;
@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSUUID* sessionUUID;
@property (nonatomic, strong) NSString* udid;

@end

@interface AALogger ()

@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSDictionary* manifests; // { sessionId : manifestData }
@property (nonatomic, strong) NSDictionary* actions; // { sessionId : mutable array of packages }
@property (nonatomic, strong) NSTimer* serializationTimer;
@property (nonatomic, strong) NSTimer* sendingDataTimer;

@end

static NSString* const kManifestsSerializationKey   = @"uwDYiXJN1R";
static NSString* const kActionsSerializationKey     = @"seM18uY8nQ";

@implementation AALogger

#pragma mark - Life Cycle

+ (instancetype)instance
{
    static AALogger* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[AALogger alloc] init];
    });
    return _self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self deserialize];
        [self scheduleTimers];
    }
    return self;
}

// save to disk in xml format
- (void)serialize
{
    [[NSUserDefaults standardUserDefaults] setObject:self.manifests forKey:kManifestsSerializationKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.actions forKey:kActionsSerializationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deserialize
{
    self.manifests = [[NSUserDefaults standardUserDefaults] objectForKey:kManifestsSerializationKey];
    self.actions = [[NSUserDefaults standardUserDefaults] objectForKey:kActionsSerializationKey];
    if (!self.manifests)
    {
        self.manifests = [NSDictionary dictionary];
    }
    if (!self.actions)
    {
        self.actions = [NSDictionary dictionary];
    }
}

- (void)dealloc
{
    [self invalidateTimers];
}

#pragma mark - Properties

- (BOOL)isManifestSent
{
    return self.manifests && self.manifests.count == 0;
}

#pragma mark - Working with Data

// serialization and dispatch timers
- (void)scheduleTimers
{
    self.serializationTimer = [NSTimer
                               scheduledTimerWithTimeInterval:kGTSerializationInterval
                               target:self
                               selector:@selector(serialize)
                               userInfo:nil
                               repeats:YES];
    
    self.sendingDataTimer = [NSTimer
                             scheduledTimerWithTimeInterval:kGTSendingDataInterval
                             target:self
                             selector:@selector(sendData)
                             userInfo:nil
                             repeats:YES];
}

- (void)invalidateTimers
{
    [self.serializationTimer invalidate];
    [self.sendingDataTimer invalidate];
}

- (void)sendData
{
    [AppAnalytics checkInitialization];
    
    // if no Internet of manifest hasn't been sent yet
    if (![[AFNetworkReachabilityManager sharedManager] isReachable] ||
        !self.isManifestSent)
    {
        return;
    }
    
    [self sendSamples];
    [self sendManifests];
}

- (void)sendSamples
{    
    if (!self.actions.allKeys.count)
    {
        return;
    }
    
    // iterate through all samples, prepare data to send
    // format { session_id : array_of_samples_1, ... , array_of_samples_n }
    // make sure each array doesn't exceed threshold
    
    NSMutableDictionary* allSessionsPackages = [NSMutableDictionary dictionary];
    NSMutableDictionary* samplesToRemove = [NSMutableDictionary dictionary];
    for (NSString* sessionID in self.actions.allKeys)
    {
        NSMutableArray* wholeSessionPackage = [NSMutableArray array];
        NSMutableData* sessionChunk = [[NSMutableData alloc] initWithData:[AAManifestBuilder instance].headerData];
        int sizeInBytes = 0;
        
        for (NSData* sample in self.actions[sessionID])
        {
            sizeInBytes += sample.length;
            [sessionChunk appendData:sample];
            if (sizeInBytes > kGTMaxSamplesSizeInBytes)
            {
                [wholeSessionPackage addObject:sessionChunk];
                sessionChunk = [NSMutableData data];
                sizeInBytes = 0;
            }
        }
        
        if (sessionChunk.length > 0)
            [wholeSessionPackage addObject:sessionChunk];
        
        allSessionsPackages[sessionID] = wholeSessionPackage;
        samplesToRemove[sessionID] = @([self.actions[sessionID] count]);
    }
    
    __weak __typeof(self) weakSelf = self;

    // send and cleanup on success
    [[AAConnectionManager instance] PUTsamples:allSessionsPackages success:^
    {
        [weakSelf cleanupSamples:samplesToRemove];
    }];
}

- (void)sendManifests
{
    if (!self.manifests.allKeys.count)
    {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    // send and cleanup on success
    [[AAConnectionManager instance] PUTmanifests:self.manifests success:^
    {
        weakSelf.manifests = [NSDictionary dictionary];
    }];
}

- (void)cleanupSamples:(NSDictionary*)samplesToRemove
{
    NSMutableDictionary* cleanedActions = self.actions.mutableCopy;
    for (NSString* sessionID in self.actions.allKeys)
    {
        int objectsToRemove = (int) [samplesToRemove[sessionID] integerValue];
        NSRange cleanupRange = NSMakeRange(0, MIN(objectsToRemove, [self.actions[sessionID] count]));
        
        if (cleanupRange.length == [self.actions[sessionID] count])
        {
            [cleanedActions removeObjectForKey:sessionID];
        }
        else
        {
            [cleanedActions[sessionID] removeObjectsInRange:cleanupRange];
        }
    }
    self.actions = cleanedActions;
    cleanedActions = nil;
    [self serialize];
}

#pragma mark - Adding Actions

// Touch-based sample
- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    AAGestureDetails* details = [[AAGestureDetails alloc] initWithGestureRecognizer:gestureRecognizer index:self.index++];
    [self addAction:details];
}

- (void)gestureRecognized:(ActionType)type
          triggerPosition:(CGPoint)position
            triggerViewID:(NSString *)viewID
{
    AAGestureDetails* details = [[AAGestureDetails alloc] initWithType:type
                                                   triggerPosition:position
                                                     triggerViewID:viewID
                                                             index:self.index++];
    [self addAction:details];
}

// Navigation-based sample
- (void)navigationRecognizedWithViewControllerID:(NSString *)viewControllerID
{
    AANavigationDetails* details = [[AANavigationDetails alloc] initWithIndex:self.index++
                                                  triggerViewControllerID:viewControllerID];
    [self addAction:details];
}

// Shake-based sample
- (void)shakeRecognized
{
    AAShakeDetails* details = [[AAShakeDetails alloc] init];
    [self addAction:details];
}

- (void)createSessionManifest
{
    NSData* manifest = [[AAManifestBuilder instance] builSessionManifest];
    NSMutableDictionary* manifests = self.manifests.mutableCopy;
    manifests[[AppAnalytics instance].sessionUUID.UUIDString] = manifest;
    self.manifests = manifests.copy;
    [self sendManifests];
}

// Add sample to array
- (void)addAction:(id<LogInfo>)actionDetails
{
    NSData* actionData = [[AAManifestBuilder instance] buildDataPackage:actionDetails];
    NSMutableDictionary* actions = self.actions.mutableCopy;
    NSMutableArray* sessionActions = actions[[AppAnalytics instance].sessionUUID.UUIDString];
    if (!sessionActions)
    {
        sessionActions = [NSMutableArray array];
    }
    [sessionActions addObject:actionData];
    actions[[AppAnalytics instance].sessionUUID.UUIDString] = sessionActions;
    self.actions = actions.copy;
    
    // log if needed for debug purposes
#ifdef DEBUG
#warning Uncomment this if needed
//    [self printDebugInfo:actionDetails];
#endif
}

#pragma mark - Debug Helpers

// Used to log sample info in debug purposes
- (void)printDebugInfo:(id<LogInfo>)actionDetails
{
    NSLog(@"Order ID [%lu]", (unsigned long)actionDetails.index);
    NSLog(@"Type [%@ -> %d]", NSStringWithActionType(actionDetails.type), actionDetails.type);
    NSLog(@"Time [%@]", actionDetails.timestamp);
    NSLog(@"Position X [%.3f]", actionDetails.position.x);
    NSLog(@"Position Y [%.3f]", actionDetails.position.y);
    NSLog(@"Param1 [%f]", actionDetails.info);
    NSLog(@"Triggered VC ID [%@]", actionDetails.triggerViewControllerID);
    NSLog(@"Triggered Element ID [%@]", actionDetails.triggerViewID);
    NSLog(@"-----------------------------");
}

// Log event to console
- (void)debugLogEvent:(AAEvent *)event
{
    if (event.parameters)
    {
        NSLog(@"AppAnalytics: Event [%@] recorded. Parameters %@", event.descriptionText, event.parameters.description);
    }
    else
    {
        NSLog(@"AppAnalytics: Event [%@] recorded", event.descriptionText);
    }
    NSLog(@"indices%@\ntimestamps%@", event.indices, event.timestamps);
}

@end
