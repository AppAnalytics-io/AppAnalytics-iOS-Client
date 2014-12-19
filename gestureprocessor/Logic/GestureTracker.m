#import "GestureTracker.h"
#import "GestureTrackerConfig.h"
#import "Logger.h"
#import "GestureDetails.h"

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
                                   initWithTarget:self action:@selector(onGestureRecognized:)];
    tap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onGestureRecognized:)];
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:doubleTap];
    
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onGestureRecognized:)];
    tripleTap.numberOfTapsRequired = 3;
    [doubleTap requireGestureRecognizerToFail:tripleTap];
    
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onGestureRecognized:)];
    longTap.minimumPressDuration = kLongTapDuration;
    
    for (UIGestureRecognizer* gesture in @[tap, doubleTap, tripleTap, longTap])
    {
        [window addGestureRecognizer:gesture];
    }
}

- (void)onGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    [[Logger instance] gestureRecognized:gestureRecognizer];
}

- (void)onTap:(UITapGestureRecognizer*)tap
{

}

- (void)onLongTap:(UILongPressGestureRecognizer*)longTap
{

}

- (void)onDoubleTap:(UITapGestureRecognizer*)doubleTap
{

}

@end
