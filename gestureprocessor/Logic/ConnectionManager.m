#import "ConnectionManager.h"
#import "GTConstants.h"
#import "AFHTTPRequestOperation.h"
#import "HMFJSONResponseSerializerWithData.h"
#import "ManifestBuilder.h"
#import "GestureTracker.h"

@interface GestureTracker (Connection)
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
        _sharedClient.responseSerializer.acceptableContentTypes = contentTypes;
    });
    
    return _sharedClient;
}

- (void)PUTManifest:(NSData*)rawManifest sessionID:(NSString*)sessionID success:(void (^)())success
{
    NSString* url = [NSString stringWithFormat:@"manifests?UDID=%@", [GestureTracker instance].udid];

    [self PUT:url
   parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:[ManifestBuilder instance].headerData
                                    name:@"header"
                                fileName:@"DataPackageFileHeader.datapackage"
                                mimeType:@"application/octet-stream"];
         
        [formData appendPartWithFileData:[ManifestBuilder instance].headerData
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
    
    NSString* url = [NSString stringWithFormat:@"samples?UDID=%@", [GestureTracker instance].udid];
    NSString* filename = [NSString stringWithFormat:@"%@_%d.datapackage", sessionID, ++samplesPackageIndex];
    
    [self PUT:url
   parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:[ManifestBuilder instance].headerData
                                     name:@"header"
                                 fileName:@"DataPackageFileHeader.datapackage"
                                 mimeType:@"application/octet-stream"];
         
         [formData appendPartWithFileData:[ManifestBuilder instance].headerData
                                     name:@"Samples"
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
         NSLog(@"PUT Manifest error: %@", error);
     }];
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
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

#if 0
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
[request setURL:[NSURL URLWithString:url]];
[request setHTTPMethod:@"PUT"];
NSMutableData *body = [NSMutableData data];
NSString *boundary = @"---------------------------14737809831466499882746641449";
NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
[request addValue:contentType forHTTPHeaderField: @"Content-Type"];

[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
[body appendData:[NSData dataWithData:self.manifests[udid]]];
[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

// close form
[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

// setting the body of the post to the reqeust
[request setHTTPBody:body];

NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
NSLog(@"%@",dict);
#endif

@end
