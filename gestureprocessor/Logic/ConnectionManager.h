#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface ConnectionManager : AFHTTPSessionManager

+ (instancetype)instance;

@end
