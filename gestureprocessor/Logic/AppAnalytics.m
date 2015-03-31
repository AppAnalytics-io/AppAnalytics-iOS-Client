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
@property (nonatomic, readwrite) BOOL screenAnalyticEnabled;
@property (nonatomic, readwrite) BOOL debugLogEnabled;
@property (nonatomic, readwrite) BOOL popupAnalyticEnabled;
@property (nonatomic, readwrite) BOOL motionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL locationServicesAnalyticEnabled;
@property (nonatomic, readwrite) BOOL connectionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL applicationStateAnalyticEnabled;
@property (nonatomic, readwrite) BOOL deviceOrientationAnalyticEnabled;
@property (nonatomic, readwrite) BOOL batteryAnalyticEnabled;
@property (nonatomic, readwrite) BOOL keyboardAnalyticsEnabled;

@end

@interface AppAnalytics () <UIGestureRecognizerDelegate>

+ (instancetype)instance;
- (void)trackWindowGestures:(UIWindow*)window;
- (void)onShake;
+ (void)checkInitialization;

@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSUUID* sessionUUID;
@property (nonatomic, strong) NSString* udid;
@property (nonatomic) BOOL heatMapAnalyticsEnabled;

@end

static NSString* const kUDIDKey = @"NHzZ36186S";

NSString* const DebugLog                     = @"DebugLog";
NSString* const HeatMapAnalytics             = @"HeatMapAnalytics";
NSString* const ExceptionAnalytics           = @"ExceptionAnalytics";
NSString* const TransactionAnalytics         = @"TransactionAnalytics";
NSString* const NavigationAnalytics          = @"NavigationAnalytics";
NSString* const PopUpAnalytics               = @"PopUpAnalytics";
NSString* const MotionAnalytics              = @"MotionAnalytics";
NSString* const LocationServicesAnalytics    = @"LocationServicesAnalytics";
NSString* const ConnectionAnalytics          = @"ConnectionAnalytics";
NSString* const ApplicationStateAnalytics    = @"ApplicationStateAnalytics";
NSString* const DeviceOrientationAnalytics   = @"DeviceOrientationAnalytics";
NSString* const BatteryAnalytics             = @"BatteryAnalytics";
NSString* const KeyboardAnalytics            = @"KeyboardAnalytics";

@implementation AppAnalytics

#pragma mark - Life Cycle

+ (void)initWithAppKey:(NSString *)appKey
{
    if ([AppAnalytics instance].appKey)
    {
        return;
    }
    
    [AppAnalyticsHelpers checkAppKey:appKey];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [AppAnalytics instance].appKey = appKey;
    [KeyboardWatcher instance];
    [EventsObserver instance];
    [[Logger instance] createSessionManifest];
}

+ (void)initWithAppKey:(NSString *)appKey options:(NSDictionary*)options
{
    [self initWithAppKey:appKey];
    
    if (!options)
    {
        return;
    }
    
    [self setOptions:options];
}

+ (void)setOptions:(NSDictionary*)options
{
    NSArray* optionsKeys = options.allKeys;
    
    for (NSString* key in optionsKeys)
    {
        if (![options[key] isKindOfClass:[NSNumber class]] ||
            !(options[key] == (void*)kCFBooleanFalse || options[key] == (void*)kCFBooleanTrue))
        {
            NSString* reason = [NSString stringWithFormat:@"Please, use @(YES) or @(NO) in options dictionary for key '%@'.", key];
            [[NSException exceptionWithName:kSDKExceptionName
                                     reason:reason
                                   userInfo:nil] raise];
        }
    }
    
    if ([optionsKeys containsObject:DebugLog])
        [self setDebugLogEnabled:[options[DebugLog] boolValue]];
    
    if ([optionsKeys containsObject:HeatMapAnalytics])
        [self setHeatMapAnalyticsEnabled:[options[HeatMapAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:ExceptionAnalytics])
        [self setExceptionAnalyticsEnabled:[options[ExceptionAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:TransactionAnalytics])
        [self setTransactionAnalyticsEnabled:[options[TransactionAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:NavigationAnalytics])
        [self setNavigationAnalyticsEnabled:[options[NavigationAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:PopUpAnalytics])
        [self setPopUpsAnalyticsEnabled:[options[PopUpAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:MotionAnalytics])
        [self setMotionAnalyticsEnabled:[options[MotionAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:LocationServicesAnalytics])
        [self setLocationServicesAnalyticsEnabled:[options[LocationServicesAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:ConnectionAnalytics])
        [self setConnectionAnalyticsEnabled:[options[ConnectionAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:ApplicationStateAnalytics])
        [self setApplicationStateAnalyticsEnabled:[options[ApplicationStateAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:DeviceOrientationAnalytics])
        [self setDeviceOrientationAnalyticsEnabled:[options[DeviceOrientationAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:BatteryAnalytics])
        [self setBatteryAnalyticsEnabled:[options[BatteryAnalytics] boolValue]];
    
    if ([optionsKeys containsObject:KeyboardAnalytics])
        [self setKeyboardAnalyticsEnabled:[options[KeyboardAnalytics] boolValue]];
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
        self.heatMapAnalyticsEnabled = YES;
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

#pragma mark - Setting Options

+ (void)checkInitialization
{
    if (![AppAnalytics instance].appKey)
    {
        [AppAnalyticsHelpers raiseNotInitializedException];
    }
}

+ (void)logEvent:(NSString*)eventName
{
    [self checkInitialization];
    [[EventsManager instance] addEvent:eventName async:YES];
}

+ (void)logEvent:(NSString*)eventName parameters:(NSDictionary*)parameters
{
    [self checkInitialization];
    [[EventsManager instance] addEvent:eventName parameters:parameters async:YES];
}

+ (void)setDispatchInverval:(NSTimeInterval)dispatchInterval
{
    [self checkInitialization];
    [EventsManager instance].dispatchInterval = dispatchInterval;
}

+ (void)setDebugLogEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].debugLogEnabled = enabled;
}

+ (void)setExceptionAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].exceptionAnalyticEnabled = enabled;
}

+ (void)setTransactionAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].transactionAnalyticEnabled = enabled;
}

+ (void)setNavigationAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].screenAnalyticEnabled = enabled;
}

+ (void)setPopUpsAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].popupAnalyticEnabled = enabled;
}

+ (void)setMotionAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].motionAnalyticEnabled = enabled;
}

+ (void)setLocationServicesAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].locationServicesAnalyticEnabled = enabled;
}

+ (void)setConnectionAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].connectionAnalyticEnabled = enabled;
}

+ (void)setApplicationStateAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].applicationStateAnalyticEnabled = enabled;
}

+ (void)setDeviceOrientationAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].deviceOrientationAnalyticEnabled = enabled;
}

+ (void)setBatteryAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].batteryAnalyticEnabled = enabled;
}

+ (void)setHeatMapAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [AppAnalytics instance].heatMapAnalyticsEnabled = enabled;
}

+ (void)setKeyboardAnalyticsEnabled:(BOOL)enabled
{
    [self checkInitialization];
    [EventsManager instance].keyboardAnalyticsEnabled = enabled;
}

void uncaughtExceptionHandler(NSException *exception)
{
    [AppAnalytics checkInitialization];
    [[EventsManager instance] handleUncaughtException:exception];
}

#pragma mark - Gesture Processing

- (void)trackWindowGestures:(UIWindow*)window
{
    // Only need the window where the application is rendered
    if (![NSStringFromClass(window.class) isEqual:@"UIWindow"])
    {
        return;
    }
    
    // Init gesture recognizers
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
    
    // Attach to window
    for (UIGestureRecognizer* gesture in gestures)
    {
        gesture.delegate = self;
        gesture.cancelsTouchesInView = NO;
        [window addGestureRecognizer:gesture];
    }
}

- (void)onGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized &&
        [AppAnalytics instance].heatMapAnalyticsEnabled)
    {
        [AppAnalytics checkInitialization];
        [[Logger instance] gestureRecognized:gestureRecognizer];
    }
}

- (void)onShake
{
    if ([AppAnalytics instance].heatMapAnalyticsEnabled)
    {
        [AppAnalytics checkInitialization];
        [[Logger instance] shakeRecognized];
    }
}

#pragma mark - UIGestureRecognizerDelegate

// To allow UIContols (buttons and others) correctly receive touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    
    return YES;
}

// To recognize all gestures at once
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
