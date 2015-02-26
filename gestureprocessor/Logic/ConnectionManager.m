#import "ConnectionManager.h"
#import "GTConstants.h"
#import "ManifestBuilder.h"
#import "AppAnalytics.h"
#import "HMFJSONResponseSerializerWithData.h"
#import "AFHTTPRequestOperation.h"

@interface AppAnalytics (Connection)
+ (instancetype)instance;
@property (nonatomic, strong, readwrite) NSString* udid;
@end

@implementation ConnectionManager

+ (instancetype)instance
{
    static ConnectionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _sharedClient = [[ConnectionManager alloc] initWithBaseURL:[NSURL URLWithString:kGTBaseURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        AFJSONResponseSerializer *responseSerializer = [HMFJSONResponseSerializerWithData serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [_sharedClient setResponseSerializer:responseSerializer];
        [_sharedClient setRequestSerializer:AFJSONRequestSerializer.serializer];
        
        NSMutableSet *contentTypes = [NSMutableSet setWithSet:_sharedClient.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"multipart/form-data"];
        [contentTypes addObject:@"application/octet-stream"];
        [contentTypes addObject:@"application/jsonrequest"];
        _sharedClient.responseSerializer.acceptableContentTypes = contentTypes;
    });
    
    return _sharedClient;
}

- (void)PUTManifest:(NSData*)rawManifest sessionID:(NSString*)sessionID success:(void (^)())success
{
    NSString* url = [NSString stringWithFormat:@"manifests?UDID=%@", [AppAnalytics instance].udid];
    [self PUT:url
   parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:rawManifest
                                    name:@"Manifest"
                                fileName:[sessionID stringByAppendingString:@".manifest"]
                                mimeType:@"application/octet-stream"];
     }
      success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success)
        {
            success();
        }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"PUT Manifest error: %@", error);
    }];
}

- (void)PUTsamples:(NSData*)rawSamples sessionID:(NSString*)sessionID success:(void (^)())success
{
    static int samplesPackageIndex;
    
    NSString* url = [NSString stringWithFormat:@"samples?UDID=%@", [AppAnalytics instance].udid];
    NSString* filename = [NSString stringWithFormat:@"%@_%d.datapackage", sessionID, ++samplesPackageIndex];
    
    [self PUT:url
   parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:rawSamples
                                     name:@"Sample"
                                 fileName:filename
                                 mimeType:@"application/octet-stream"];
     }
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (success)
         {
             success();
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"PUT Samples error: %@", error);
     }];
}

- (void)PUTevents:(NSArray*)events sessionID:(NSString*)sessionID success:(void (^)())success failure:(void (^)())failure
{    
    NSString* urlString = [NSString stringWithFormat:@"events?UDID=%@", [AppAnalytics instance].udid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Events"] = events;
    parameters[@"SessionID"] = sessionID;
    
    NSString* s = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
    
    [self PUT:urlString
    parameters:nil
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
      {
          [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]
                                      name:@"Events"];
      }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          if (success)
          {
              success();
          }
      }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          NSLog(@"PUT Events error: %@", error);
          if (failure)
          {
              failure();
          }
      }];
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"PUT"
                                                                                URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
                                                                               parameters:parameters
                                                                constructingBodyWithBlock:block
                                                                                    error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}



@end
