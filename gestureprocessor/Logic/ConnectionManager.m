#import "ConnectionManager.h"
#import "GTConstants.h"
#import "AFHTTPRequestOperation.h"

@implementation ConnectionManager

+ (instancetype)instance
{
    static ConnectionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _sharedClient = [[ConnectionManager alloc] initWithBaseURL:[NSURL URLWithString:kGTBaseURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters data:data];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

-(NSMutableURLRequest*)requestWithMethod:(NSString *)method
                                    path:(NSString *)path
                              parameters:(NSDictionary *)parameters
                                    data:(NSData*)data;
{
    NSMutableURLRequest* request = [super requestWithMethod:method
                                                       path:path
                                                 parameters:parameters];
    
    [request setHTTPBody:data];
    
    return request;
}

@end
