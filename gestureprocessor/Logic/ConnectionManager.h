#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface ConnectionManager : AFHTTPRequestOperationManager

+ (instancetype)instance;

- (void)putManifest:(NSData*)rawManifest
               UDID:(NSString*)udid
            success:(void (^)())success;

@end
