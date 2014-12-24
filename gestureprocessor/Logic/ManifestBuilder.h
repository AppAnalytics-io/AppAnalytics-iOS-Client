#import <Foundation/Foundation.h>

@protocol LogInfo;

@interface ManifestBuilder : NSObject

+ (instancetype)instance;
- (NSData*)buildDataPackage:(id<LogInfo>)actionDetails;
- (NSData*)builSessionManifest;

@property (nonatomic, strong, readonly) NSData* headerData;

@end
