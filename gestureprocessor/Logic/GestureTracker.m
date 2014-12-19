#import "GestureTracker.h"
#import "GestureTrackerConfig.h"

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
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:doubleTap];
    
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onLongTap:)];
    longTap.minimumPressDuration = kLongTapDuration;
    
    for (UIGestureRecognizer* gesture in @[tap, doubleTap, longTap])
    {
        [window addGestureRecognizer:gesture];
    }
}

- (void)onTap:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized)
    {
        [self logGestureInfo:tap];
    }
}

- (void)onLongTap:(UILongPressGestureRecognizer*)longTap
{
    if (longTap.state == UIGestureRecognizerStateRecognized)
    {
        [self logGestureInfo:longTap];
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer*)doubleTap
{
    if (doubleTap.state == UIGestureRecognizerStateRecognized)
    {
        [self logGestureInfo:doubleTap];
    }
}

- (void)logGestureInfo:(UIGestureRecognizer*)gesture
{
    NSLog(@"[%@] Number of touches %lu", NSStringFromClass([gesture class]), gesture.numberOfTouches);
}

@end
