#import "ManifestBuilder.h"
#import "Logger.h"
#import "GTConstants.h"
#import "GestureTracker.h"
#import "GestureTrackerHelpers.h"

@interface GestureTracker (ManifestBuilder)

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
    [headerData appendBytes:[GestureTracker instance].sessionUUID.UUIDString.UTF8String
                     length:[GestureTracker instance].sessionUUID.UUIDString.length];
    
//    NSString *path = [[self saveDirectoryPath] stringByAppendingPathComponent:@"header"];
//    [headerData writeToFile:path atomically:YES];
//    
//    NSLog(@"Reading header");
//    [self readFileAtPath:path];
    
    return _headerData.copy;
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
    
//    [packageData writeToFile:[self actionPackagePath:(NSInteger)index] atomically:YES];
//    
//    NSLog(@"Reading packageData");
//    [self readFileAtPath:[self actionPackagePath:(NSInteger)index]];
    
    return packageData;
}

- (NSData*)builSessionManifest
{
    char beginMarker = '<';
    char endMarker = '>';
    NSTimeInterval sessionStartInterval = self.sessionStartDate.timeIntervalSince1970;
    NSTimeInterval sessionEndInterval = [NSDate new].timeIntervalSince1970;
    Version appVersion = [GestureTrackerHelpers appVersion];
    Version osVersion = [GestureTrackerHelpers OSVersion];
    double screenWidth = [GestureTrackerHelpers screenSizeInPixels].width;
    double screenHeight = [GestureTrackerHelpers screenSizeInPixels].height;
    NSString* systemLocale = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    NSMutableData* manifestData = [NSMutableData data];
    
    [manifestData appendBytes:&beginMarker length:sizeof(beginMarker)];
    [manifestData appendBytes:&kSessionManifestFileVersion length:sizeof(kSessionManifestFileVersion)];
    [manifestData appendBytes:[GestureTracker instance].sessionUUID.UUIDString.UTF8String
                       length:[GestureTracker instance].sessionUUID.UUIDString.length];
    [manifestData appendBytes:&sessionStartInterval length:sizeof(sessionStartInterval)];
    [manifestData appendBytes:&sessionEndInterval length:sizeof(sessionEndInterval)];
    [manifestData appendBytes:[GestureTracker instance].udid.UTF8String
                       length:[GestureTracker instance].udid.length];
    [manifestData appendBytes:&screenWidth length:sizeof(screenWidth)];
    [manifestData appendBytes:&screenHeight length:sizeof(screenHeight)];
    [manifestData appendBytes:&kGestureTrackerApiVersion length:sizeof(kGestureTrackerApiVersion)];
    [manifestData appendBytes:[GestureTracker instance].appKey.UTF8String length:[GestureTracker instance].appKey.length];
    
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
    
//    [manifestData writeToFile:[self manifestPath] atomically:YES];
//    NSLog(@"Reading manifestData");
//    [self readFileAtPath:[self manifestPath]];
    
    return manifestData;
}

- (NSString*)actionPackagePath:(NSInteger)index
{
    return [NSString stringWithFormat:@"%@%@%d",
            [self saveDirectoryPath], [GestureTracker instance].sessionUUID.UUIDString, index];
}

- (NSString*)manifestPath
{
    return [[self saveDirectoryPath] stringByAppendingPathComponent:@"manifest"];
}

- (NSString*)saveDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)readFileAtPath:(NSString*)path
{
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    NSUInteger length = [fileData length];
    NSLog(@"Read Success: %d bytes read", length);
#if 0
    char *fileBytes = (char *)[fileData bytes];
    NSUInteger index;
    
    for (index = 0; index<length; index++)
    {
        char aByte = fileBytes[index];
    }
#endif
}

@end
