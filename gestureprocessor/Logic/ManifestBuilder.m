#import "ManifestBuilder.h"

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
    char fileSignature = 'H' + 'A';
    u_int8_t fileVersion = 1;
    NSUUID *uuid = [NSUUID UUID];
    
}

@end
