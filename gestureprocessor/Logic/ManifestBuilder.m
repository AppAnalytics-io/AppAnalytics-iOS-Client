#import "ManifestBuilder.h"
#import "Logger.h"
#import "GestureTrackerConstants.h"
#import "GestureTracker.h"
#import "GestureTrackerHelpers.h"
#import "OpenUDID.h"

@interface GestureTracker (AppKey)

+ (instancetype)instance;
@property (nonatomic, strong) NSString* appKey;

@end

@interface ManifestBuilder ()
@property (nonatomic, strong) NSUUID* uuid;
@property (nonatomic, strong) NSDate* sessionStartDate;
@property (nonatomic, strong) NSString* udid;
@end

static NSString* const kUDIDKey = @"NHzZ36186S";

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
        self.uuid = [NSUUID UUID];
        self.sessionStartDate = [NSDate new];
        self.udid = [[NSUserDefaults standardUserDefaults] objectForKey:kUDIDKey];
        if (!self.udid)
        {
            self.udid = [[OpenUDID value] substringToIndex:32];
            [[NSUserDefaults standardUserDefaults] setObject:self.udid forKey:kUDIDKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

- (void)buildHeader
{
//    int headerLength = 39;
    char fileSignature[2] = {'H', 'A'};
    
//    char* buffer = malloc(sizeof(char) * headerLength);
//    sprintf(buffer, "%s%d%s", fileSignature, fileVersion, uuid.UUIDString.UTF8String);
//    free(buffer);
    
    NSMutableData* headerData = [NSMutableData data];
    [headerData appendBytes:&fileSignature length:sizeof(fileSignature)];
    [headerData appendBytes:&kDataPackageFileVersion length:sizeof(kDataPackageFileVersion)];
    [headerData appendBytes:self.uuid.UUIDString.UTF8String length:self.uuid.UUIDString.length];
    
    NSString *path = [[self saveDirectoryPath] stringByAppendingPathComponent:@"header"];
    [headerData writeToFile:path atomically:YES];
    
    NSLog(@"Reading header");
    [self readFileAtPath:path];
}

- (void)buildDataPackage:(id<LogInfo>)actionDetails
{
    char beginMarker = '<';
    char endMarker = '<';
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
    
    NSString *path = [[self saveDirectoryPath] stringByAppendingPathComponent:@"action"];
    [packageData writeToFile:path atomically:YES];
    
    NSLog(@"Reading packageData");
    [self readFileAtPath:path];
}

- (void)builSessionManifest
{
    char beginMarker = '<';
    char endMarker = '<';
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
    [manifestData appendBytes:self.uuid.UUIDString.UTF8String length:self.uuid.UUIDString.length];
    [manifestData appendBytes:&sessionStartInterval length:sizeof(sessionStartInterval)];
    [manifestData appendBytes:&sessionEndInterval length:sizeof(sessionEndInterval)];
    [manifestData appendBytes:self.udid.UTF8String length:self.udid.length];
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
    
    NSString *path = [[self saveDirectoryPath] stringByAppendingPathComponent:@"manifest"];
    [manifestData writeToFile:path atomically:YES];
    
    NSLog(@"Reading manifestData");
    [self readFileAtPath:path];
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
