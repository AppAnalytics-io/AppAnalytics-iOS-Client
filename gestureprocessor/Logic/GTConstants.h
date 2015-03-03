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

extern NSTimeInterval const kMaxEventsDispatchTime;
extern NSTimeInterval const kMinEventsDispatchTime;
extern NSTimeInterval const kDefaultEventsDispatchTime;

extern BOOL const kDebugLogEnabled;
extern BOOL const kExceptionAnalyticsEnabled;
extern BOOL const kTransactionAnalyticsEnabled;
extern BOOL const kScreenAnalyticsEnabled;

extern NSUInteger const kEventDescriptionMaxLength;
extern float const kEventsSerializationInterval;
extern size_t const kEventsMaxSizeInBytes;
extern size_t const kEventAverageSizeInBytes;
extern NSString*  const kEventDescriptionPlaceholder;

extern NSString* const kUncaughtExceptionEvent;
extern NSString* const kUncaughtExceptionEventReason;

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

extern NSString* const kEmptyParameter;