#import "GestureTracker.h"
#import "GTConstants.h"
#import "Logger.h"
#import "UIGestureRecognizer+Type.h"
#import "KeyboardWatcher.h"
#import "OpenUDID.h"

@interface GestureTracker () <UIGestureRecognizerDelegate>

+ (instancetype)instance;
- (void)trackWindowGestures:(UIWindow*)window;
- (void)onShake;

@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSUUID* sessionUUID;
@property (nonatomic, strong) NSString* udid;

@end

static NSString* const kUDIDKey = @"NHzZ36186S";

@implementation GestureTracker

+ (void)initWithAppKey:(NSString *)appKey
{
    [GestureTracker instance].appKey = appKey;
    [KeyboardWatcher instance];
    [[Logger instance] createSessionManifest];
}

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
        self.sessionUUID = [NSUUID UUID];
        self.udid = [[NSUserDefaults standardUserDefaults] objectForKey:kUDIDKey];
        if (!self.udid)
        {
            self.udid = [[OpenUDID value] substringToIndex:32];
            [[NSUserDefaults standardUserDefaults] setObject:self.udid forKey:kUDIDKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

- (void)trackWindowGestures:(UIWindow*)window
{
    NSMutableArray* gestures = [NSMutableArray array];
    
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(onGestureRecognized:)];
    
    UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(onGestureRecognized:)];
    
//    [pinch requireGestureRecognizerToFail:rotate];
    
    [gestures addObjectsFromArray:@[pinch, rotate]];
    
    for (int touches = 1; touches <= 4; ++touches)
    {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(onGestureRecognized:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = touches;
        
//        if (touches > 1)
//        {
//            [tap requireGestureRecognizerToFail:pinch];
//            [tap requireGestureRecognizerToFail:rotate];
//        }
        
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onGestureRecognized:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = touches;
        [tap requireGestureRecognizerToFail:doubleTap];
        
        UITapGestureRecognizer* tripleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onGestureRecognized:)];
        tripleTap.numberOfTapsRequired = 3;
        tripleTap.numberOfTouchesRequired = touches;
        [doubleTap requireGestureRecognizerToFail:tripleTap];
        
        UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(onGestureRecognized:)];
//        longTap.minimumPressDuration = kLongTapDuration;
        longTap.numberOfTouchesRequired = touches;
        
        UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(onGestureRecognized:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        leftSwipe.numberOfTouchesRequired = touches;
        
        UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(onGestureRecognized:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        rightSwipe.numberOfTouchesRequired = touches;
        
        UISwipeGestureRecognizer* upSwipe = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onGestureRecognized:)];
        upSwipe.direction =  UISwipeGestureRecognizerDirectionUp;
        upSwipe.numberOfTouchesRequired = touches;
        
        UISwipeGestureRecognizer* downSwipe = [[UISwipeGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(onGestureRecognized:)];
        downSwipe.direction =  UISwipeGestureRecognizerDirectionDown;
        downSwipe.numberOfTouchesRequired = touches;
        
//        if (touches > 2)
//        {
//            [pinch requireGestureRecognizerToFail:rightSwipe];
//            [pinch requireGestureRecognizerToFail:leftSwipe];
//            [pinch requireGestureRecognizerToFail:upSwipe];
//            [pinch requireGestureRecognizerToFail:downSwipe];
//        }
        
        [gestures addObjectsFromArray:@[tap, doubleTap, tripleTap, longTap, leftSwipe, rightSwipe, upSwipe, downSwipe]];
    }

    for (UIGestureRecognizer* gesture in gestures)
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
#if 0
    NSArray* classes = @[@"UITextView", @"UITextField", @"ADDimmerView", @"UIWebBrowserView"];
    
    if ([classes containsObject:NSStringFromClass([touch.view class])] &&
        [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        UITapGestureRecognizer* tap = (UITapGestureRecognizer*) gestureRecognizer;
        if (tap.numberOfTapsRequired == 1)
        {
            [[Logger instance] gestureRecognized:ActionType_SingleTap
                                 triggerPosition:[touch locationInView:nil]
                                   triggerViewID:NSStringFromClass([touch.view class])];

        }
    }
#endif
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    if (gestureRecognizer.isSwipe && otherGestureRecognizer.isSwipe)
//    {
//        return NO;
//    }
//    else if (gestureRecognizer.isRotate && otherGestureRecognizer.isRotate)
//    {
//        return NO;
//    }
//    else if (gestureRecognizer.isPinch && otherGestureRecognizer.isPinch)
//    {
//        return NO;
//    }
    return YES;
}

@end
