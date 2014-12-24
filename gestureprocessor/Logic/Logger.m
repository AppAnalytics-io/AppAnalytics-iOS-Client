#import "Logger.h"
#import "GestureDetails.h"
#import "ShakeDetails.h"
#import "NavigationDetails.h"
#import "ManifestBuilder.h"
#import "ConnectionManager.h"
#import "GestureTracker.h"

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

@end

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
        self.manifests = [NSDictionary dictionary];
        self.actions = [NSDictionary dictionary];
    }
    return self;
}

#pragma mark - Sending Data

- (void)scheduleManifest
{
    
}

- (void)schedulePackages
{
    
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
