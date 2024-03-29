#import "AAConnectionManager.h"
#import "GTConstants.h"
#import "AAManifestBuilder.h"
#import "AppAnalytics.h"
#import "HMFJSONResponseSerializerWithData.h"
#import "AFHTTPRequestOperation.h"
#import "AAHardware.h"

@interface AppAnalytics (Connection)
+ (instancetype)instance;
@property (nonatomic, strong, readwrite) NSString* udid;
@end

@implementation AAConnectionManager

+ (instancetype)instance
{
    static AAConnectionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _sharedClient = [[AAConnectionManager alloc] initWithBaseURL:[NSURL URLWithString:kGTBaseURL]];
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

- (void)PUTmanifests:(NSDictionary *)manifests success:(void (^)())success
{
    NSString* url = [NSString stringWithFormat:@"manifests?UDID=%@", [AppAnalytics instance].udid];
    NSDictionary* parameters = @{ kModelNameParameter : [AAHardware modelName] };
    
    [self PUT:url
   parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]
                                     name:kHardware];
         
         for (NSString* sessionID in manifests.allKeys)
         {
             [formData appendPartWithFileData:manifests[sessionID]
                                         name:@"Manifest"
                                     fileName:[sessionID stringByAppendingString:@".manifest"]
                                     mimeType:@"application/octet-stream"];
         }
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
#ifdef DEBUG
         NSLog(@"PUT Manifest error: %@", error);
#endif
     }];
}

- (void)PUTsamples:(NSDictionary *)samples success:(void (^)())success
{
    static int samplesPackageIndex;
    
    NSString* url = [NSString stringWithFormat:@"samples?UDID=%@", [AppAnalytics instance].udid];
    
    [self PUT:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        for (NSString* sessionID in samples.allKeys)
        {
            for (NSData* rawSamples in samples[sessionID])
            {
                NSString* filename = [NSString stringWithFormat:@"%@_%d.datapackage", sessionID, ++samplesPackageIndex];
                [formData appendPartWithFileData:rawSamples
                                            name:@"Sample"
                                        fileName:filename
                                        mimeType:@"application/octet-stream"];
            }
        }
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
#ifdef DEBUG
        NSLog(@"PUT Samples error: %@", error);
#endif
    }];
}

- (void)PUTevents:(NSArray*)events sessionID:(NSString*)sessionID success:(void (^)())success failure:(void (^)())failure
{    
    NSString* urlString = [NSString stringWithFormat:@"events?UDID=%@", [AppAnalytics instance].udid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Events"] = events;
    parameters[@"SessionID"] = sessionID;
    
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
#ifdef DEBUG
          NSLog(@"PUT Events error: %@", error);
#endif
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
