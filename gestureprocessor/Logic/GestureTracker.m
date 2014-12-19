#import "GestureTracker.h"

@implementation GestureTracker

+ (instancetype)instance
{
    static GestureTracker* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[GestureTracker alloc] init];
    });
    return _self;
}

- (void)trackWindowGestures:(UIWindow*)window
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onTap:)];
    [window addGestureRecognizer:tap];
}

- (void)onTap:(UITapGestureRecognizer*)tap
{
    [self logGestureInfo:tap];
}

- (void)logGestureInfo:(UIGestureRecognizer*)gesture
{
    NSLog(@"Number of touches %lu", gesture.numberOfTouches);
}

@end
