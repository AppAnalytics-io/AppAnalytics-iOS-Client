#import <Foundation/Foundation.h>

@protocol LogInfo;
@class Event;

@interface ManifestBuilder : NSObject

+ (instancetype)instance;
- (NSData*)buildDataPackage:(id<LogInfo>)actionDetails;
- (NSData*)builSessionManifest;
- (NSDictionary*)buildEventJSONDict:(Event*)event;
- (NSData*)buildEventsJSONPackage:(NSArray*)JSONDicts;

@property (nonatomic, strong, readonly) NSData* headerData;

@end
