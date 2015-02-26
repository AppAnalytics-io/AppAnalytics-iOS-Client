#import <Foundation/Foundation.h>
#import "NamespacedDependencies.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface ConnectionManager : AFHTTPRequestOperationManager

+ (instancetype)instance;

- (void)PUTManifest:(NSData*)rawManifest
          sessionID:(NSString*)sessionID
            success:(void (^)())success;

- (void)PUTsamples:(NSData*)rawSamples
         sessionID:(NSString*)sessionID
           success:(void (^)())success;

- (void)PUTevents:(NSArray*)events
        sessionID:(NSString*)sessionID
          success:(void (^)())success
          failure:(void (^)())failure;

@end
