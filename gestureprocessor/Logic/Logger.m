#import "Logger.h"
#import "GestureDetails.h"
#import "ShakeDetails.h"
#import "NavigationDetails.h"
#import "ManifestBuilder.h"
#import "GestureTracker.h"
#import "GTConstants.h"
#import "UNIRest.h"
#import "ConnectionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface GestureDetails (Tracking)

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;

@end

@interface ShakeDetails (Tracking)

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;

@end

@interface GestureTracker (Logger)

+ (instancetype)instance;
@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSUUID* sessionUUID;
@property (nonatomic, strong) NSString* udid;

@end

@interface Logger ()

@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSDictionary* manifests; // { sessionId : manifestData }
@property (nonatomic, strong) NSDictionary* actions; // { sessionId : mutable array of packages }
@property (nonatomic, strong) NSTimer* serializationTimer;
@property (nonatomic, strong) NSTimer* sendingDataTimer;

@end

static NSString* const kManifestsSerializationKey   = @"uwDYiXJN1R";
static NSString* const kActionsSerializationKey     = @"seM18uY8nQ";

@implementation Logger

#pragma mark - Life Cycle

+ (instancetype)instance
{
    static Logger* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[Logger alloc] init];
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

#pragma mark - Working with Data

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
    [self sendSamples];
    [self sendManifests];
}

- (void)sendSamples
{
    if (!self.actions.allKeys.count)
    {
        return;
    }
    
    NSMutableDictionary* actions = [NSMutableDictionary dictionary];
    int sizeInBytes = 0;
    for (NSString* sessionID in self.actions.allKeys)
    {
        BOOL exceedsMaxSize = NO;
        NSArray* sessionsSamples = self.actions[sessionID];
        for (NSData* sample in sessionsSamples)
        {
            sizeInBytes += sample.length;
            if (sizeInBytes > kGTMaxSamplesSizeInBytes)
            {
                exceedsMaxSize = YES;
                break;
            }
            NSMutableArray* sessionActions = actions[sessionID];
            if (!sessionActions)
            {
                sessionActions = [NSMutableArray array];
            }
            [sessionActions addObject:sample];
            actions[sessionID] = sessionActions;
        }
        if (exceedsMaxSize)
        {
            break;
        }
    }
    
    NSString* sessionID = [GestureTracker instance].sessionUUID.UUIDString;
    __weak Logger* weakSelf = self;

    [[ConnectionManager instance]
     PUTsamples:[self allSamplesData:actions]
     sessionID:sessionID
     success:^
    {
        [self removeUploadedSamples:actions];
        [weakSelf serialize];
    }];
}

- (void)sendManifests
{
    if (!self.manifests.allKeys.count)
    {
        return;
    }
    
    for (NSString* sessionID in self.manifests.allKeys)
    {
        __weak Logger* weakSelf = self;
        
        [[ConnectionManager instance] PUTManifest:self.manifests[sessionID] sessionID:sessionID success:^
        {
            [self removeManifestForSessionID:sessionID];
            [weakSelf serialize];
        }];
    }
}

- (void)removeManifestForSessionID:(NSString*)sessionID
{
    NSMutableDictionary* manifests = self.manifests.mutableCopy;
    [manifests removeObjectForKey:sessionID];
    self.manifests = manifests.copy;
}

- (void)removeUploadedSamples:(NSDictionary*)actionsToRemove
{
    NSMutableDictionary* actions = self.actions.mutableCopy;
    for (NSString* sessionID in actionsToRemove.allKeys)
    {
        NSArray* sessionSamplesToRemove = actionsToRemove[sessionID];
        NSMutableArray* sessionSamples = actions[sessionID];
        for (NSData* sample in sessionSamplesToRemove)
        {
            if ([sessionSamples containsObject:sample])
            {
                [sessionSamples removeObject:sessionSamples];
            }
        }
        actions[sessionID] = sessionSamples;
    }
}

- (NSData*)allSamplesData:(NSDictionary*)actionsDictionary
{
    NSMutableData* allSamplesData = [NSMutableData data];
    
    for (NSString* sessionID in self.actions.allKeys)
    {
        NSArray* sessionsSamples = self.actions[sessionID];
        for (NSData* sample in sessionsSamples)
        {
            [allSamplesData appendData:sample];
        }
    }
    
    return allSamplesData.copy;
}

#pragma mark - Logging

- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    GestureDetails* details = [[GestureDetails alloc] initWithGestureRecognizer:gestureRecognizer index:self.index++];
    [self addAction:details];
}

- (void)gestureRecognized:(ActionType)type
          triggerPosition:(CGPoint)position
            triggerViewID:(NSString *)viewID
{
    GestureDetails* details = [[GestureDetails alloc] initWithType:type
                                                   triggerPosition:position
                                                     triggerViewID:viewID
                                                             index:self.index++];
    [self addAction:details];
}

- (void)navigationRecognizedWithViewControllerID:(NSString *)viewControllerID
{
    NavigationDetails* details = [[NavigationDetails alloc] initWithIndex:self.index++
                                                  triggerViewControllerID:viewControllerID];
    [self addAction:details];
}

- (void)shakeRecognized
{
    ShakeDetails* details = [[ShakeDetails alloc] init];
    [self addAction:details];
}

- (void)createSessionManifest
{
    NSData* manifest = [[ManifestBuilder instance] builSessionManifest];
    NSMutableDictionary* manifests = self.manifests.mutableCopy;
    manifests[[GestureTracker instance].sessionUUID.UUIDString] = manifest;
    self.manifests = manifests.copy;
    [self sendManifests];
}

- (void)addAction:(id<LogInfo>)actionDetails
{
    NSData* actionData = [[ManifestBuilder instance] buildDataPackage:actionDetails];
    NSMutableDictionary* actions = self.actions.mutableCopy;
    NSMutableArray* sessionActions = actions[[GestureTracker instance].sessionUUID.UUIDString];
    if (!sessionActions)
    {
        sessionActions = [NSMutableArray array];
    }
    [sessionActions addObject:actionData];
    actions[[GestureTracker instance].sessionUUID.UUIDString] = sessionActions;
    self.actions = actions.copy;
//    [self printDebugInfo:actionDetails];
}

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

@end
