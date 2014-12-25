#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface ConnectionManager : AFHTTPRequestOperationManager

+ (instancetype)instance;

- (void)putManifest:(NSData*)rawManifest
          sessionID:(NSString*)sessionID
            success:(void (^)())success;

@end
