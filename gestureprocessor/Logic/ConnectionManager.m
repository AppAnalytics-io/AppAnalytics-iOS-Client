#import "ConnectionManager.h"
#import "HMFJSONResponseSerializerWithData.h"
#import "GTConstants.h"

@implementation ConnectionManager

#pragma mark - Life Cycle
+ (instancetype)instance
{
    static ConnectionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        NSURL *baseURL = [NSURL URLWithString:kGTBaseURL];
        NSURL *relativeURL = [NSURL URLWithString:kGTRelativeURL relativeToURL:baseURL];
        _sharedClient = [[ConnectionManager alloc] initWithBaseURL:relativeURL];
        AFJSONResponseSerializer *responseSerializer = [HMFJSONResponseSerializerWithData
                                                        serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [_sharedClient setResponseSerializer:responseSerializer];
        [_sharedClient setRequestSerializer:AFJSONRequestSerializer.serializer];
        
        NSMutableSet *contentTypes = [NSMutableSet setWithSet:_sharedClient.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/plain"];
        _sharedClient.responseSerializer.acceptableContentTypes = contentTypes;
    });
    
    return _sharedClient;
}

- (void)putManifest:(NSData*)manifest
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *request = kGTManifestsURL;
//    NSDictionary *params = @{@"rating": rating,
//                             @"tip" : tip};
    [self PUT:request parameters:manifest success:success failure:failure];
}

@end
