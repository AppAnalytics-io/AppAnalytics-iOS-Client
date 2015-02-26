#import "ManifestBuilder.h"
#import "Logger.h"
#import "GTConstants.h"
#import "AppAnalytics.h"
#import "AppAnalyticsHelpers.h"
#import "Event.h"

@interface AppAnalytics (ManifestBuilder)

+ (instancetype)instance;
@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSUUID* sessionUUID;
@property (nonatomic, strong) NSString* udid;

@end

@interface ManifestBuilder ()
@property (nonatomic, strong) NSDate* sessionStartDate;
@property (nonatomic, strong, readwrite) NSData* headerData;
@end


@implementation ManifestBuilder

+ (instancetype)instance
{
    static ManifestBuilder* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[ManifestBuilder alloc] init];
    });
    return _self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.sessionStartDate = [NSDate new];
    }
    return self;
}

- (NSData*)headerData
{
    if (!_headerData)
    {
        _headerData = [self buildHeader];
    }
    return _headerData;
}

- (NSData*)buildHeader
{
    char fileSignature[2] = {'H', 'A'};

    NSMutableData* headerData = [NSMutableData data];
    [headerData appendBytes:&fileSignature length:sizeof(fileSignature)];
    [headerData appendBytes:&kDataPackageFileVersion length:sizeof(kDataPackageFileVersion)];
    [headerData appendBytes:[AppAnalytics instance].sessionUUID.UUIDString.UTF8String
                     length:[AppAnalytics instance].sessionUUID.UUIDString.length];
    
    return headerData;
}

- (NSData*)buildDataPackage:(id<LogInfo>)actionDetails
{
    char beginMarker = '<';
    char endMarker = '>';
    u_int64_t index = actionDetails.index;
    u_int8_t type = actionDetails.type;
    NSTimeInterval timestamp = actionDetails.timestamp.timeIntervalSince1970;
    double posX = actionDetails.position.x;
    double posY = actionDetails.position.y;
    float param1 = actionDetails.info;
    u_int16_t viewIDLength = actionDetails.triggerViewControllerID.length;
    u_int16_t elementIDLength = actionDetails.triggerViewID.length;

    NSMutableData* packageData = [NSMutableData data];
    
    [packageData appendBytes:&beginMarker length:sizeof(beginMarker)];
    [packageData appendBytes:&index length:sizeof(index)];
    [packageData appendBytes:&type length:sizeof(type)];
    [packageData appendBytes:&timestamp length:sizeof(timestamp)];
    [packageData appendBytes:&posX length:sizeof(posX)];
    [packageData appendBytes:&posY length:sizeof(posY)];
    [packageData appendBytes:&param1 length:sizeof(param1)];
    [packageData appendBytes:&viewIDLength length:sizeof(viewIDLength)];
    [packageData appendBytes:actionDetails.triggerViewControllerID.UTF8String length:viewIDLength];
    [packageData appendBytes:&elementIDLength length:sizeof(elementIDLength)];
    [packageData appendBytes:actionDetails.triggerViewID.UTF8String length:elementIDLength];
    [packageData appendBytes:&endMarker length:sizeof(endMarker)];
    
    return packageData;
}

- (NSData*)builSessionManifest
{
    char beginMarker = '<';
    char endMarker = '>';
    NSTimeInterval sessionStartInterval = self.sessionStartDate.timeIntervalSince1970;
    NSTimeInterval sessionEndInterval = [NSDate new].timeIntervalSince1970;
    Version appVersion = [AppAnalyticsHelpers appVersion];
    Version osVersion = [AppAnalyticsHelpers OSVersion];
    double screenWidth = [AppAnalyticsHelpers screenSizeInPixels].width / [UIScreen mainScreen].scale;
    double screenHeight = [AppAnalyticsHelpers screenSizeInPixels].height / [UIScreen mainScreen].scale;
    NSString* systemLocale = [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
                              stringByPaddingToLength:3 withString:@" " startingAtIndex:0];
    
    NSMutableData* manifestData = [NSMutableData data];
    
    [manifestData appendBytes:&beginMarker length:sizeof(beginMarker)];
    [manifestData appendBytes:&kSessionManifestFileVersion length:sizeof(kSessionManifestFileVersion)];
    [manifestData appendBytes:[AppAnalytics instance].sessionUUID.UUIDString.UTF8String
                       length:[AppAnalytics instance].sessionUUID.UUIDString.length];
    [manifestData appendBytes:&sessionStartInterval length:sizeof(sessionStartInterval)];
    [manifestData appendBytes:&sessionEndInterval length:sizeof(sessionEndInterval)];
    [manifestData appendBytes:[AppAnalytics instance].udid.UTF8String
                       length:[AppAnalytics instance].udid.length];
    [manifestData appendBytes:&screenWidth length:sizeof(screenWidth)];
    [manifestData appendBytes:&screenHeight length:sizeof(screenHeight)];
    [manifestData appendBytes:&kAppAnalyticsApiVersion length:sizeof(kAppAnalyticsApiVersion)];
    [manifestData appendBytes:[AppAnalytics instance].appKey.UTF8String length:[AppAnalytics instance].appKey.length];
    
    [manifestData appendBytes:&appVersion.major length:sizeof(appVersion.major)];
    [manifestData appendBytes:&appVersion.minor length:sizeof(appVersion.minor)];
    [manifestData appendBytes:&appVersion.build length:sizeof(appVersion.build)];
    [manifestData appendBytes:&appVersion.revision length:sizeof(appVersion.revision)];
    
    [manifestData appendBytes:&osVersion.major length:sizeof(osVersion.major)];
    [manifestData appendBytes:&osVersion.minor length:sizeof(osVersion.minor)];
    [manifestData appendBytes:&osVersion.build length:sizeof(osVersion.build)];
    [manifestData appendBytes:&osVersion.revision length:sizeof(osVersion.revision)];

    [manifestData appendBytes:systemLocale.UTF8String length:systemLocale.length];
    [manifestData appendBytes:&endMarker length:sizeof(endMarker)];
    
    return manifestData;
}

static NSString* const kIndicesKey    = @"ActionOrder";
static NSString* const kTimeStampsKey = @"ActionTime";
static NSString* const kEventNameKey  = @"EventName";
static NSString* const kEventParametersKey  = @"EventParameters";

- (NSDictionary*)buildEventJSONDict:(Event*)event
{
    NSMutableDictionary* JSONDict = [NSMutableDictionary dictionary];
    
    if (event.indices)
        JSONDict[kIndicesKey] = event.indices;
    
    if (event.timestamps)
        JSONDict[kTimeStampsKey] = event.timestamps;
    
    JSONDict[kEventNameKey] = event.descriptionText ? event.descriptionText : kEventDescriptionPlaceholder;
    
    if (event.parameters)
        JSONDict[kEventParametersKey] = event.parameters;
    
    return JSONDict;
}

- (NSData*)buildEventsJSONPackage:(NSArray*)JSONDicts
{
    return [NSJSONSerialization dataWithJSONObject:JSONDicts options:0 error:nil];
}

@end
