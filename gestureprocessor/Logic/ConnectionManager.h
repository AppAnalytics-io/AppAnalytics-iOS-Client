#import <Foundation/Foundation.h>
#import "NamespacedDependencies.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface ConnectionManager : AFHTTPRequestOperationManager

+ (instancetype)instance;

- (void)PUTmanifests:(NSDictionary*)manifests
             success:(void (^)())success;

- (void)PUTsamples:(NSDictionary*)samples
           success:(void (^)())success;

- (void)PUTevents:(NSArray*)events
        sessionID:(NSString*)sessionID
          success:(void (^)())success
          failure:(void (^)())failure;

@end
