#import "EventsObserver.h"
#import "EventsManager.h"
#import "GTConstants.h"
#import "AFNetworkReachabilityManager.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface EventsObserver () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CMAltimeter* altimeterManager;
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, strong) CMMotionActivityManager* motionActivityManager;
@end

@implementation EventsObserver

#pragma mark - Life Cycle

+ (instancetype)instance
{
    static EventsObserver* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[EventsObserver alloc] init];
    });
    return _self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
        [self addObservers];
    }
    return self;
}

- (void)dealloc
{
    [self removeObservers];
    [self.altimeterManager stopRelativeAltitudeUpdates];
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionActivityManager stopActivityUpdates];
    
    self.locationManager = nil;
    self.altimeterManager = nil;
    self.motionManager = nil;
    self.motionActivityManager = nil;
}

- (void)setup
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    self.motionActivityManager = [[CMMotionActivityManager alloc] init];
    
#if 0
    [self configureAltitude];
    [self configureMotion];
    [self configureMotionActivity];
#endif
}

- (void)configureMotion
{
    if (self.motionManager.isDeviceMotionAvailable)
    {
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                                toQueue:[NSOperationQueue mainQueue]
                                                            withHandler:^(CMDeviceMotion *motion, NSError *error)
         {
             CGFloat x = motion.gravity.x;
             CGFloat y = motion.gravity.y;
             CGFloat z = motion.gravity.z;
             NSLog(@"%f %f %f", x, y, z);
         }];
    }
}

- (void)configureMotionActivity
{
    if ([CMMotionActivityManager isActivityAvailable])
    {
        [self.motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                                    withHandler:^(CMMotionActivity *activity)
        {
            if ([EventsManager instance].motionAnalyticEnabled)
            {
                [[EventsManager instance] addEvent:kMotionActivityChanged
                                        parameters:@{ kMotionActivityState : [EventsObserver activityTypeString:activity] }
                                             async:YES];
            }
        }];
    }
}

- (void)addObservers
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    UIDevice* device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onOrientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:device];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onApplicationStateChanged:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onApplicationStateChanged:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onBatteryStateChanged:)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    __weak __typeof(self) weakSelf = self;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         [weakSelf onConnectionStatusChanged:status];
     }];
}

- (void)removeObservers
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceBatteryStateDidChangeNotification
                                                  object:nil];
    
    [self.altimeterManager stopRelativeAltitudeUpdates];
}

#pragma mark - Battery

- (void)onBatteryStateChanged:(NSNotification *)note
{
    if (![EventsManager instance].batteryAnalyticEnabled)
    {
        return;
    }
    
    NSString* stateString = nil;
    switch ([UIDevice currentDevice].batteryState)
    {
        case UIDeviceBatteryStateUnplugged:
            stateString = kBatteryStateUnplugged;
            break;
        case UIDeviceBatteryStateCharging:
            stateString = kBatteryStateCharging;
            break;
        case UIDeviceBatteryStateFull:
            stateString = kBatteryStateFull;
            break;
        default:
            stateString = kBatteryStateUnknown;
            break;
    }
    [[EventsManager instance] addEvent:kBatteryStateChanged
                            parameters:@{ kBatteryState : stateString }
                                 async:YES];
}

#pragma mark - Location Services

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![EventsManager instance].locationServicesAnalyticEnabled)
    {
        return;
    }
    
    NSString* statusString = nil;
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            statusString = kLocationServicesNotDetermined;
            break;
        case kCLAuthorizationStatusRestricted:
            statusString = kLocationServicesRestricted;
            break;
        case kCLAuthorizationStatusDenied:
            statusString = kLocationServicesDenied;
            break;
#ifdef __IPHONE_8_0
        case kCLAuthorizationStatusAuthorizedAlways:
            statusString = kLocationServicesAuthorisedAlways;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            statusString = kLocationServicesAuthorisedWhenInUse;
            break;
#else
        case kCLAuthorizationStatusAuthorized:
            statusString = kLocationServicesAuthorisedAlways;
            break;
#endif
        default:
            statusString = kLocationServicesNotDetermined;
            break;
    }
    [[EventsManager instance] addEvent:kLocationServicesStatusChanged
                            parameters:@{ kLocationServicesStatus : statusString }
                                 async:YES];
}

#pragma mark - Connection Status

- (void)onConnectionStatusChanged:(AFNetworkReachabilityStatus)status
{
    if (![EventsManager instance].connectionAnalyticEnabled)
    {
        return;
    }
    
    NSString* statusString = nil;
    switch (status)
    {
        case AFNetworkReachabilityStatusNotReachable:
            statusString = kConnectionStatusNone;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            statusString = kConnectionStatusWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            statusString = kConnectionStatusWiFi;
            break;
        default:
            statusString = kConnectionStatusUnknown;
            break;
    }
    [[EventsManager instance] addEvent:kConnectionStatusChanged
                            parameters:@{ kConnectionStatusParameter : statusString }
                                 async:YES];
}

#pragma mark - Entering Background / Foreground

- (void)onApplicationStateChanged:(NSNotification *)note
{
    if (![EventsManager instance].applicationStateAnalyticEnabled)
    {
        return;
    }
    
    [[EventsManager instance] addEvent:kAppStateChangedEvent
                            parameters:@{ kAppStateParameter : note.name }
                                 async:NO];
}

#pragma mark - Device Orientation

- (void)onOrientationChanged:(NSNotification *)note
{
    if (![EventsManager instance].deviceOrientationAnalyticEnabled)
    {
        return;
    }
    
    if ([note.object isKindOfClass:[UIDevice class]])
    {
        NSString* orientationString = nil;
        switch ([[note object] orientation])
        {
            case UIDeviceOrientationPortrait:
                orientationString = kOrientationChangedPortait;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                orientationString = kOrientationChangedUpsideDown;
                break;
            case UIDeviceOrientationLandscapeLeft:
                orientationString = kOrientationChangedLandscapeLeft;
                break;
            case UIDeviceOrientationLandscapeRight:
                orientationString = kOrientationChangedLandscapeRight;
                break;
            case UIDeviceOrientationFaceUp:
                orientationString = kOrientationChangedFaceUp;
                break;
            case UIDeviceOrientationFaceDown:
                orientationString = kOrientationChangedFaceDown;
                break;
            default:
                orientationString = kOrientationChangedUnknown;
                break;
        }
        [[EventsManager instance] addEvent:kOrientationChangedEvent
                                parameters:@{ kOrientationParameter : orientationString }
                                     async:YES];
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    if (![EventsManager instance].transactionAnalyticEnabled)
    {
        return;
    }
    
    for (SKPaymentTransaction * transaction in transactions)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        parameters[kTransactionEventId] = transaction.payment.productIdentifier;
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                parameters[kTransactionEventType] = kTransactionStatePurchasing;
                break;
            case SKPaymentTransactionStatePurchased:
                parameters[kTransactionEventType] = kTransactionStateSucceeded;
                break;
            case SKPaymentTransactionStateFailed:
                parameters[kTransactionEventType] = kTransactionStateFailed;
                break;
            case SKPaymentTransactionStateRestored:
                parameters[kTransactionEventType] = kTransactionStateRestored;
                break;
            case SKPaymentTransactionStateDeferred:
                parameters[kTransactionEventType] = kTransactionStateDeferred;
                break;
            default:
                break;
        }
        
        [[EventsManager instance] addEvent:kTransactionEvent parameters:parameters.copy async:YES];
    }
}

#pragma mark - Helpers

+ (NSString *)activityTypeString:(CMMotionActivity *)activity
{
    if (activity.walking)
        return @"Walking";
    else if (activity.running)
        return @"Running";
    else if (activity.automotive)
        return @"Automotive";
    else if (activity.stationary)
        return @"Not Moving";
    else if (!activity.unknown)
        return @"Moving";
    else
        return @"Unclassified";
}

@end
