#import <Foundation/Foundation.h>

extern u_int8_t const kSessionManifestFileVersion;
extern u_int8_t const kDataPackageFileVersion;
extern u_int8_t const kAppAnalyticsApiVersion;

extern float const kGTSerializationInterval;
extern float const kGTSendingDataInterval;
extern size_t const kGTMaxSamplesSizeInBytes;

extern NSString* const kGTBaseURL;
extern NSString* const kGTRelativeURL;
extern NSString* const kGTManifestsURL;
extern NSString* const kGTSamplesURL;
extern NSString* const kEventsFullURL;

extern NSString* const kPortraitParameter;
extern NSString* const kLandscapeParameter;
extern NSString* const kUnknownOrientationParameter;
extern NSString* const kUnresponsiveSampleParameter;
extern NSString* const kResponsiveSampleParameter;

extern NSTimeInterval const kMaxEventsDispatchTime;
extern NSTimeInterval const kMinEventsDispatchTime;
extern NSTimeInterval const kDefaultEventsDispatchTime;

extern NSString* const kSDKExceptionName;

extern NSString* const kHardware;
extern NSString* const kModelNameParameter;

extern BOOL const kDebugLogEnabled;

extern NSUInteger const kEventDescriptionMaxLength;
extern float const kEventsSerializationInterval;
extern size_t const kEventsMaxSizeInBytes;
extern size_t const kEventAverageSizeInBytes;

// Exceptions
extern NSString* const kExceptionEvent;
extern NSString* const kExceptionEventReason;
extern NSString* const kExceptionEventName;
extern NSString* const kExceptionEventCallStack;

// Transactions
extern NSString* const kTransactionEvent;
extern NSString* const kTransactionEventType;
extern NSString* const kTransactionEventId;
extern NSString* const kTransactionStatePurchasing;
extern NSString* const kTransactionStateSucceeded;
extern NSString* const kTransactionStateFailed;
extern NSString* const kTransactionStateRestored;
extern NSString* const kTransactionStateDeferred;

extern NSString* const kNavigationEvent;
extern NSString* const kNavigationEventClassName;

extern NSString* const kAlertEvent;
extern NSString* const kAlertTitle;
extern NSString* const kAlertMessage;

extern NSString* const kNullParameter;

// Device orientation
extern NSString* const kOrientationChangedEvent;
extern NSString* const kOrientationParameter;
extern NSString* const kOrientationChangedPortait;
extern NSString* const kOrientationChangedUpsideDown;
extern NSString* const kOrientationChangedLandscapeLeft;
extern NSString* const kOrientationChangedLandscapeRight;
extern NSString* const kOrientationChangedFaceUp;
extern NSString* const kOrientationChangedFaceDown;
extern NSString* const kOrientationChangedUnknown;

// Application State
extern NSString* const kAppStateChangedEvent;
extern NSString* const kAppStateParameter;
extern NSString* const kAppStateForeground;
extern NSString* const kAppStateBackground;

// Internet Connection
extern NSString* const kConnectionStatusChanged;
extern NSString* const kConnectionStatusParameter;
extern NSString* const kConnectionStatusWiFi;
extern NSString* const kConnectionStatusWWAN;
extern NSString* const kConnectionStatusNone;
extern NSString* const kConnectionStatusUnknown;

// Keyboard
extern NSString* const kKeyboardStateChanged;
extern NSString* const kKeyboardStateParameter;
extern NSString* const kKeyboardVisible;
extern NSString* const kKeyboardHidden;

// Location Services
extern NSString* const kLocationServicesStatusChanged;
extern NSString* const kLocationServicesStatus;
extern NSString* const kLocationServicesNotDetermined;
extern NSString* const kLocationServicesRestricted;
extern NSString* const kLocationServicesDenied;
extern NSString* const kLocationServicesAuthorisedAlways;
extern NSString* const kLocationServicesAuthorisedWhenInUse;

// Battery
extern NSString* const kBatteryStateChanged;
extern NSString* const kBatteryState;
extern NSString* const kBatteryStateUnknown;
extern NSString* const kBatteryStateUnplugged;
extern NSString* const kBatteryStateCharging;
extern NSString* const kBatteryStateFull;

// Motion
extern NSString* const kMotionActivityChanged;
extern NSString* const kMotionActivityState;