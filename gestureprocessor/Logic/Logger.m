#import "Logger.h"
#import "GestureDetails.h"

@interface Logger ()

@property (nonatomic, strong, readwrite) NSMutableArray* gestures; // of GestureDetails

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
        self.gestures = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Logging

- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    GestureDetails *details = [[GestureDetails alloc] initWithGestureRecognizer:gestureRecognizer];
    [self.gestures addObject:details];
    
    NSLog(@"%@", details.info);
}

@end
