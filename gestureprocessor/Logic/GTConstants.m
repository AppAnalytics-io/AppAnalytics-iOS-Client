#import "GTConstants.h"

u_int8_t const kSessionManifestFileVersion   = 1;
u_int8_t const kDataPackageFileVersion       = 1;
u_int8_t const kAppAnalyticsApiVersion       = 1;

size_t const kGTMaxSamplesSizeInBytes   = 1024 * 100;
float const kGTSerializationInterval    = 15.0f;
float const kGTSendingDataInterval      = 60.0f;

NSString* const kGTBaseURL      = @"http://wa-api-cent-us-1.cloudapp.net/api/v1";
//@"http://www.appanalytics.io/api/v1"; // @"http://192.168.1.36:6249/api/v1";
NSString* const kGTManifestsURL = @"manifests";
NSString* const kGTSamplesURL   = @"samples";
NSString* const kEventsFullURL  = @"http://wa-api-cent-us-1.cloudapp.net/api/v1/events";
#warning kDefaultEventsDispatchTime
NSTimeInterval const kMaxEventsDispatchTime = 3600.0f;
NSTimeInterval const kMinEventsDispatchTime = 10.0f;
NSTimeInterval const kDefaultEventsDispatchTime = 10.0f;//120.0f;

BOOL const kDebugLogEnabled = YES;
BOOL const kExceptionAnalyticsEnabled = YES;
BOOL const kTransactionAnalyticsEnabled = YES;
BOOL const kScreenAnalyticsEnabled = NO;

NSUInteger const kEventDescriptionMaxLength = 256;
float      const kEventsSerializationInterval = 15.0f;
size_t     const kEventsMaxSizeInBytes = 1024 * 100;
size_t     const kEventAverageSizeInBytes = 120;
NSString*  const kEventDescriptionPlaceholder = @"null";

NSString* const kUncaughtExceptionEvent = @"Uncaught Exception";
NSString* const kUncaughtExceptionEventReason = @"Reason";

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