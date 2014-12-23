#import "ManifestBuilder.h"
#import "Logger.h"

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

- (void)buildHeader
{
//    int headerLength = 39;
    char fileSignature[2] = {'H', 'A'};
    u_int8_t fileVersion = 1;
    NSUUID* uuid = [NSUUID UUID];
    
//    char* buffer = malloc(sizeof(char) * headerLength);
//    sprintf(buffer, "%s%d%s", fileSignature, fileVersion, uuid.UUIDString.UTF8String);
//    free(buffer);
    
    NSMutableData* headerData = [NSMutableData data];
    [headerData appendBytes:&fileSignature length:sizeof(fileSignature)];
    [headerData appendBytes:&fileVersion length:sizeof(fileVersion)];
    [headerData appendBytes:uuid.UUIDString.UTF8String length:uuid.UUIDString.length];
    
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
