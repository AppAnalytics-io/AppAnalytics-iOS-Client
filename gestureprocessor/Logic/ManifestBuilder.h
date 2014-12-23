#import <Foundation/Foundation.h>

@protocol LogInfo;

@interface ManifestBuilder : NSObject

+ (instancetype)instance;
- (void)buildHeader;
- (void)buildDataPackage:(id<LogInfo>)actionDetails;
- (void)builSessionManifest;

@end
