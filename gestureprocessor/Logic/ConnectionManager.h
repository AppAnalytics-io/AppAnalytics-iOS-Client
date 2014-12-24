#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface ConnectionManager : AFHTTPSessionManager

+ (instancetype)instance;

- (void)putManifest:(NSData*)manifest
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
