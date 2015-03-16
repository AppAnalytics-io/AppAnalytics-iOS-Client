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

NSString* const kExceptionEvent          = @"Uncaught Exception";
NSString* const kExceptionEventReason    = @"Reason";
NSString* const kExceptionEventName      = @"Name";
NSString* const kExceptionEventCallStack = @"Call Stack Trace";

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
