#import "GTConstants.h"

u_int8_t const kSessionManifestFileVersion      = 1;
u_int8_t const kDataPackageFileVersion          = 1;
u_int8_t const kGestureProcessorApiVersion      = 1;

size_t const kGTMaxSamplesSizeInBytes   = 1024 * 100;
float const kGTSerializationInterval    = 15.0f;
float const kGTSendingDataInterval      = 30.0f;

NSString* const kGTBaseURL      = @"http://www.appanalytics.io/api/v1";
NSString* const kGTManifestsURL = @"manifests";
NSString* const kGTSamplesURL   = @"samples";

