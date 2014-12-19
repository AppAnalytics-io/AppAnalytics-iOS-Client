#import "Logger.h"
#import "GestureDetails.h"
#import "ShakeDetails.h"

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

@interface Logger ()

@property (nonatomic, strong, readwrite) NSMutableArray* actions; // of id<LogInfo>

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
        self.actions = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Logging

static NSUInteger gIndex = 0;

- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    GestureDetails* details = [[GestureDetails alloc] initWithGestureRecognizer:gestureRecognizer];
    details.index = gIndex++;
    [self.actions addObject:details];
    [self printDebugInfo:details];
}

- (void)shakeRecognized
{
    ShakeDetails* details = [[ShakeDetails alloc] init];
    details.index = gIndex++;
    [self.actions addObject:details];
}

- (void)printDebugInfo:(id<LogInfo>)actionDetails
{
    NSLog(@"Order ID %lu", actionDetails.index);
    NSLog(@"Type %@", actionDetails.typeTextName);
    NSLog(@"Time %@", actionDetails.timestamp);
    NSLog(@"Position X %.3f", actionDetails.position.x);
    NSLog(@"Position Y %.3f", actionDetails.position.y);
    NSLog(@"Param1 %@", actionDetails.info);
    NSLog(@"Triggered View Controller ID %@", actionDetails.triggerViewControllerID);
    NSLog(@"Triggered View ID %@", actionDetails.triggerViewID);
}

@end
