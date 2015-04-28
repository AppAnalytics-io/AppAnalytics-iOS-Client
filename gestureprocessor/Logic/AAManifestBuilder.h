#import <Foundation/Foundation.h>

@protocol LogInfo;
@class AAEvent;

@interface AAManifestBuilder : NSObject

+ (instancetype)instance;
- (NSData*)buildDataPackage:(id<LogInfo>)actionDetails;
- (NSData*)builSessionManifest;
- (NSDictionary*)buildEventJSONDict:(AAEvent*)event;
- (NSData*)buildEventsJSONPackage:(NSArray*)JSONDicts;

@property (nonatomic, strong, readonly) NSData* headerData;

@end
