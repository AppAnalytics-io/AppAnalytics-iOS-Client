#import "GTConstants.h"

u_int8_t const kSessionManifestFileVersion   = 1;
u_int8_t const kDataPackageFileVersion       = 1;
u_int8_t const kAppAnalyticsApiVersion       = 1;

size_t const kGTMaxSamplesSizeInBytes   = 1024 * 100;
float const kGTSerializationInterval    = 15.0f;
float const kGTSendingDataInterval      = 60.0f;

NSString* const kGTBaseURL      = @"http://wa-api-cent-us-1.cloudapp.net/api/v2";
//NSString* const kGTBaseURL      = @"http://192.168.0.23:4250/api/v2";
NSString* const kGTManifestsURL = @"manifests";
NSString* const kGTSamplesURL   = @"samples";
NSString* const kEventsFullURL  = @"http://wa-api-cent-us-1.cloudapp.net/api/v2/events";

NSTimeInterval const kMaxEventsDispatchTime = 3600.0f;
NSTimeInterval const kMinEventsDispatchTime = 10.0f;
NSTimeInterval const kDefaultEventsDispatchTime = 120.0f;

NSString* const kHardware = @"Hardware";
NSString* const kModelNameParameter = @"Model Name";

NSString* const kPortraitParameter           = @"P";
NSString* const kLandscapeParameter          = @"L";
NSString* const kUnknownOrientationParameter = @"N";
NSString* const kUnresponsiveSampleParameter = @"U";
NSString* const kResponsiveSampleParameter   = @"R";

BOOL const kDebugLogEnabled = NO;
BOOL const kExceptionAnalyticsEnabled = YES;
BOOL const kTransactionAnalyticsEnabled = YES;
BOOL const kScreenAnalyticsEnabled = NO;
BOOL const kPopupAnalyticsEnabled = YES;

NSUInteger const kEventDescriptionMaxLength = 256;
float      const kEventsSerializationInterval = 15.0f;
size_t     const kEventsMaxSizeInBytes = 1024 * 100;
size_t     const kEventAverageSizeInBytes = 120;

// Exceptions
NSString* const kExceptionEvent          = @"Uncaught Exception";
NSString* const kExceptionEventReason    = @"Reason";
NSString* const kExceptionEventName      = @"Name";
NSString* const kExceptionEventCallStack = @"Call Stack Trace";

// Transactions
NSString* const kTransactionEvent           = @"Transaction";
NSString* const kTransactionEventType       = @"Type";
NSString* const kTransactionEventId         = @"Identifier";
NSString* const kTransactionStatePurchasing = @"Transaction Initiated";
NSString* const kTransactionStateSucceeded  = @"Transaction Succeeded";
NSString* const kTransactionStateFailed     = @"Transaction Failed";
NSString* const kTransactionStateRestored   = @"Transaction Restored";
NSString* const kTransactionStateDeferred   = @"Transaction Deferred";

NSString* const kNavigationEvent            = @"Navigation";
NSString* const kNavigationEventClassName   = @"Screen Class Name";

NSString* const kAlertEvent   = @"Pop Up";
NSString* const kAlertTitle   = @"Title";
NSString* const kAlertMessage = @"Message";

NSString* const kNullParameter = @"Null";

// Device orientation
NSString* const kOrientationChangedEvent            = @"Orientation Changed";
NSString* const kOrientationParameter               = @"Orientation";
NSString* const kOrientationChangedPortait          = @"Portrait";
NSString* const kOrientationChangedUpsideDown       = @"Portrait Upside Down";
NSString* const kOrientationChangedLandscapeLeft    = @"Landscape Left";
NSString* const kOrientationChangedLandscapeRight   = @"Landscape Right";
NSString* const kOrientationChangedFaceUp           = @"Face Up";
NSString* const kOrientationChangedFaceDown         = @"Face Down";
NSString* const kOrientationChangedUnknown          = @"Unknown";

// Application State
NSString* const kAppStateChangedEvent = @"Application State Changed";
NSString* const kAppStateParameter    = @"State";
NSString* const kAppStateForeground   = @"Foreground";
NSString* const kAppStateBackground   = @"Background";

// Internet Connection
NSString* const kConnectionStatusChanged   = @"Connection Status Changed";
NSString* const kConnectionStatusParameter = @"Status";
NSString* const kConnectionStatusWiFi      = @"WiFi";
NSString* const kConnectionStatusWWAN      = @"Cellular";
NSString* const kConnectionStatusNone      = @"None";
NSString* const kConnectionStatusUnknown   = @"Unknown";

// Keyboard
NSString* const kKeyboardStateChanged = @"Keyboard State Changed";
NSString* const kKeyboardStateParameter = @"State";
NSString* const kKeyboardVisible = @"Visible";
NSString* const kKeyboardHidden = @"Hidden";

// Location Services
NSString* const kLocationServicesStatusChanged = @"Location Services Status Changed";
NSString* const kLocationServicesStatus = @"Status";
NSString* const kLocationServicesNotDetermined = @"Not Determined";
NSString* const kLocationServicesRestricted = @"Restricted";
NSString* const kLocationServicesDenied = @"Denied";
NSString* const kLocationServicesAuthorisedAlways = @"Authorised Foreground and Background Usage";
NSString* const kLocationServicesAuthorisedWhenInUse = @"Authorised Foreground Usage";

// Battery
NSString* const kBatteryStateChanged = @"Battery State Changed";
NSString* const kBatteryState = @"State";
NSString* const kBatteryStateUnknown = @"Unknown";
NSString* const kBatteryStateUnplugged = @"Unplugged";
NSString* const kBatteryStateCharging = @"Charging";
NSString* const kBatteryStateFull = @"Full";

// Motion
NSString* const kMotionActivityChanged = @"Motion Activity Changed";
NSString* const kMotionActivityState = @"State";