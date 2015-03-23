#import "AppAnalytics.h"
#import "GTConstants.h"
#import "Logger.h"
#import "UIGestureRecognizer+Type.h"
#import "KeyboardWatcher.h"
#import "AppAnalyticsHelpers.h"
#import "EventsManager.h"
#import "NamespacedDependencies.h"
#import "OpenUDID.h"
#import "AFNetworkReachabilityManager.h"
#import "EventsObserver.h"

@interface EventsManager (AppAnalytics)

@property (nonatomic, readwrite) NSTimeInterval dispatchInterval;
@property (nonatomic, readwrite) BOOL exceptionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL transactionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL navigationAnalyticEnabled;
@property (nonatomic, readwrite) BOOL debugLogEnabled;
@property (nonatomic, readwrite) BOOL popupAnalyticEnabled;

@end

@interface AppAnalytics () <UIGestureRecognizerDelegate>

+ (instancetype)instance;
- (void)trackWindowGestures:(UIWindow*)window;
- (void)onShake;

@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSUUID* sessionUUID;
@property (nonatomic, strong) NSString* udid;

@end

static NSString* const kUDIDKey = @"NHzZ36186S";

@implementation AppAnalytics

#pragma mark - Life Cycle

+ (void)initWithAppKey:(NSString *)appKey
{
    [AppAnalyticsHelpers checkAppKey:appKey];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [AppAnalytics instance].appKey = appKey;
    [KeyboardWatcher instance];
    [EventsObserver instance];
    [[Logger instance] createSessionManifest];
}

+ (instancetype)instance
{
    static AppAnalytics* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[AppAnalytics alloc] init];
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

#pragma mark - Events Processing

+ (void)logEvent:(NSString*)description
{
    [[EventsManager instance] addEvent:description async:YES];
}

+ (void)logEvent:(NSString*)description parameters:(NSDictionary*)parameters
{
    [[EventsManager instance] addEvent:description parameters:parameters async:YES];
}

+ (void)setDispatchInverval:(NSTimeInterval)dispatchInterval
{
    [EventsManager instance].dispatchInterval = dispatchInterval;
}

+ (void)setDebugLogEnabled:(BOOL)enabled
{
    [EventsManager instance].debugLogEnabled = enabled;
}

+ (void)setExceptionAnalyticsEnabled:(BOOL)enabled
{
    [EventsManager instance].exceptionAnalyticEnabled = enabled;
}

+ (void)setTransactionAnalyticsEnabled:(BOOL)enabled
{
    [EventsManager instance].transactionAnalyticEnabled = enabled;
}

+ (void)setNavigationAnalyticsEnabled:(BOOL)enabled
{
    [EventsManager instance].navigationAnalyticEnabled = enabled;
}

+ (void)setPopUpsAnalyticsEnabled:(BOOL)enabled
{
    [EventsManager instance].popupAnalyticEnabled = enabled;
}

void uncaughtExceptionHandler(NSException *exception)
{
    [[EventsManager instance] handleUncaughtException:exception];
}

#pragma mark - Gesture Processing

- (void)trackWindowGestures:(UIWindow*)window
{
    if (![NSStringFromClass(window.class) isEqual:@"UIWindow"])
    {
        return;
    }
    
    NSMutableArray* gestures = [NSMutableArray array];
    
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(onGestureRecognized:)];
    
    UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(onGestureRecognized:)];
        
    [gestures addObjectsFromArray:@[pinch, rotate]];
    
    for (int touches = 1; touches <= 4; ++touches)
    {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(onGestureRecognized:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = touches;
        
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
        
        [gestures addObjectsFromArray:@[tap, doubleTap, tripleTap, longTap, leftSwipe, rightSwipe, upSwipe, downSwipe]];
    }

    for (UIGestureRecognizer* gesture in gestures)
    {
        gesture.delegate = self;
        gesture.cancelsTouchesInView = NO;
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
    if ([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
