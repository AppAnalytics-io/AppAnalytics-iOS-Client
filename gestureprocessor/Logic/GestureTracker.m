#import "GestureTracker.h"
#import "GestureTrackerConfig.h"
#import "Logger.h"

@interface GestureTracker () <UIGestureRecognizerDelegate>

@end

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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardTouched:)
//                                                     name:UITextFieldTextDidChangeNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardTouched:)
//                                                     name:UITextViewTextDidChangeNotification
//                                                   object:nil];
    }
    return self;
}

- (void)trackWindowGestures:(UIWindow*)window
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(onGestureRecognized:)];
    tap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onGestureRecognized:)];
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:doubleTap];
    
    UITapGestureRecognizer* tripleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onGestureRecognized:)];
    tripleTap.numberOfTapsRequired = 3;
    [doubleTap requireGestureRecognizerToFail:tripleTap];
    
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onGestureRecognized:)];
    longTap.minimumPressDuration = kLongTapDuration;
    
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(onGestureRecognized:)];
    
    UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(onGestureRecognized:)];
    
    UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(onGestureRecognized:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(onGestureRecognized:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer* upSwipe = [[UISwipeGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onGestureRecognized:)];
    upSwipe.direction =  UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer* downSwipe = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(onGestureRecognized:)];
    downSwipe.direction =  UISwipeGestureRecognizerDirectionDown;
    
    for (UIGestureRecognizer* gesture in @[tap, doubleTap, tripleTap, longTap, pinch,
                                           rotate, leftSwipe, rightSwipe, upSwipe, downSwipe])
    {
        gesture.delegate = self;
        [window addGestureRecognizer:gesture];
    }
}

- (void)onGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized)
    {
        [[Logger instance] gestureRecognized:gestureRecognizer];
    }
}

- (void)onShake
{
    [[Logger instance] shakeRecognized];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end
