#import "AAEventsObserver.h"
#import "AAEventsManager.h"
#import "GTConstants.h"
#import "AFNetworkReachabilityManager.h"
#import <CoreLocation/CoreLocation.h>

@interface AAEventsObserver () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation AAEventsObserver

#pragma mark - Life Cycle

+ (instancetype)instance
{
    static AAEventsObserver* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[AAEventsObserver alloc] init];
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
    
    self.locationManager = nil;
}

- (void)setup
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
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
}

#pragma mark - Battery

- (void)onBatteryStateChanged:(NSNotification *)note
{
    if (![AAEventsManager instance].batteryAnalyticEnabled)
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
    [[AAEventsManager instance] addEvent:kBatteryStateChanged
                            parameters:@{ kBatteryState : stateString }
                                 async:YES];
}

#pragma mark - Location Services

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![AAEventsManager instance].locationServicesAnalyticEnabled)
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
    [[AAEventsManager instance] addEvent:kLocationServicesStatusChanged
                            parameters:@{ kLocationServicesStatus : statusString }
                                 async:YES];
}

#pragma mark - Connection Status

- (void)onConnectionStatusChanged:(AFNetworkReachabilityStatus)status
{
    if (![AAEventsManager instance].connectionAnalyticEnabled)
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
    [[AAEventsManager instance] addEvent:kConnectionStatusChanged
                            parameters:@{ kConnectionStatusParameter : statusString }
                                 async:YES];
}

#pragma mark - Entering Background / Foreground

- (void)onApplicationStateChanged:(NSNotification *)note
{
    if (![AAEventsManager instance].applicationStateAnalyticEnabled)
    {
        return;
    }
    
    [[AAEventsManager instance] addEvent:kAppStateChangedEvent
                            parameters:@{ kAppStateParameter : note.name }
                                 async:NO];
}

#pragma mark - Device Orientation

- (void)onOrientationChanged:(NSNotification *)note
{
    if (![AAEventsManager instance].deviceOrientationAnalyticEnabled)
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
        [[AAEventsManager instance] addEvent:kOrientationChangedEvent
                                parameters:@{ kOrientationParameter : orientationString }
                                     async:YES];
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    if (![AAEventsManager instance].transactionAnalyticEnabled)
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
        
        [[AAEventsManager instance] addEvent:kTransactionEvent parameters:parameters.copy async:YES];
    }
}

@end