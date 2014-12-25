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
@property (nonatomic, strong) NSDictionary* actions; // { sessionId : array of packages }
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
    [self sendActions];
    [self sendManifests];
}

- (void)sendActions
{

}

- (void)sendManifests
{
    if (!self.manifests.allKeys.count)
    {
        return;
    }
    
    NSString* udid = [GestureTracker instance].udid;
//    __weak Logger* weakSelf = self;
    
    [[ConnectionManager instance] putManifest:self.manifests[udid] UDID:udid success:^
    {
//        [self removeManifestsForSessionID:udid];
//        [weakSelf serialize];
    }];
}

- (void)removeManifestsForSessionID:(NSString*)sessionID
{
    NSMutableDictionary* manifests = self.manifests.mutableCopy;
    [manifests removeObjectForKey:sessionID];
    self.manifests = manifests.copy;
}

- (NSArray*)allSamplesData
{
    NSMutableArray* allSamples = [NSMutableArray array];
    
    for (NSString* sessionId in self.actions.allKeys)
    {
        [allSamples addObjectsFromArray:self.actions[sessionId]];
    }
    
    return allSamples.copy;
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
    
    [self serialize];
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
