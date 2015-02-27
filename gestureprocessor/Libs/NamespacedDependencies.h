// Namespaced Header

#ifndef __NS_SYMBOL
// We need to have multiple levels of macros here so that __NAMESPACE_PREFIX_ is
// properly replaced by the time we concatenate the namespace prefix.
#define __NS_REWRITE(ns, symbol) ns ## _ ## symbol
#define __NS_BRIDGE(ns, symbol) __NS_REWRITE(ns, symbol)
#define __NS_SYMBOL(symbol) __NS_BRIDGE(AA, symbol)
#endif


// Classes
#ifndef AA_AFCompoundResponseSerializer
#define AA_AFCompoundResponseSerializer __NS_SYMBOL(AA_AFCompoundResponseSerializer)
#endif

#ifndef AA_AFHTTPBodyPart
#define AA_AFHTTPBodyPart __NS_SYMBOL(AA_AFHTTPBodyPart)
#endif

#ifndef AA_AFHTTPRequestOperation
#define AA_AFHTTPRequestOperation __NS_SYMBOL(AA_AFHTTPRequestOperation)
#endif

#ifndef AA_AFHTTPRequestOperationManager
#define AA_AFHTTPRequestOperationManager __NS_SYMBOL(AA_AFHTTPRequestOperationManager)
#endif

#ifndef AA_AFHTTPRequestSerializer
#define AA_AFHTTPRequestSerializer __NS_SYMBOL(AA_AFHTTPRequestSerializer)
#endif

#ifndef AA_AFHTTPResponseSerializer
#define AA_AFHTTPResponseSerializer __NS_SYMBOL(AA_AFHTTPResponseSerializer)
#endif

#ifndef AA_AFHTTPSessionManager
#define AA_AFHTTPSessionManager __NS_SYMBOL(AA_AFHTTPSessionManager)
#endif

#ifndef AA_AFImageResponseSerializer
#define AA_AFImageResponseSerializer __NS_SYMBOL(AA_AFImageResponseSerializer)
#endif

#ifndef AA_AFJSONRequestSerializer
#define AA_AFJSONRequestSerializer __NS_SYMBOL(AA_AFJSONRequestSerializer)
#endif

#ifndef AA_AFJSONResponseSerializer
#define AA_AFJSONResponseSerializer __NS_SYMBOL(AA_AFJSONResponseSerializer)
#endif

#ifndef AA_AFMultipartBodyStream
#define AA_AFMultipartBodyStream __NS_SYMBOL(AA_AFMultipartBodyStream)
#endif

#ifndef AA_AFNetworkReachabilityManager
#define AA_AFNetworkReachabilityManager __NS_SYMBOL(AA_AFNetworkReachabilityManager)
#endif

#ifndef AA_AFPropertyListRequestSerializer
#define AA_AFPropertyListRequestSerializer __NS_SYMBOL(AA_AFPropertyListRequestSerializer)
#endif

#ifndef AA_AFPropertyListResponseSerializer
#define AA_AFPropertyListResponseSerializer __NS_SYMBOL(AA_AFPropertyListResponseSerializer)
#endif

#ifndef AA_AFQueryStringPair
#define AA_AFQueryStringPair __NS_SYMBOL(AA_AFQueryStringPair)
#endif

#ifndef AA_AFSecurityPolicy
#define AA_AFSecurityPolicy __NS_SYMBOL(AA_AFSecurityPolicy)
#endif

#ifndef AA_AFStreamingMultipartFormData
#define AA_AFStreamingMultipartFormData __NS_SYMBOL(AA_AFStreamingMultipartFormData)
#endif

#ifndef AA_AFURLConnectionOperation
#define AA_AFURLConnectionOperation __NS_SYMBOL(AA_AFURLConnectionOperation)
#endif

#ifndef AA_AFURLSessionManager
#define AA_AFURLSessionManager __NS_SYMBOL(AA_AFURLSessionManager)
#endif

#ifndef AA_AFURLSessionManagerTaskDelegate
#define AA_AFURLSessionManagerTaskDelegate __NS_SYMBOL(AA_AFURLSessionManagerTaskDelegate)
#endif

#ifndef AA_AFXMLParserResponseSerializer
#define AA_AFXMLParserResponseSerializer __NS_SYMBOL(AA_AFXMLParserResponseSerializer)
#endif

#ifndef AA_OpenUDID
#define AA_OpenUDID __NS_SYMBOL(AA_OpenUDID)
#endif

// Functions
#ifndef AA_AFStringFromNetworkReachabilityStatus
#define AA_AFStringFromNetworkReachabilityStatus __NS_SYMBOL(AA_AFStringFromNetworkReachabilityStatus)
#endif

#ifndef AA_AFStringFromNetworkReachabilityStatus
#define AA_AFStringFromNetworkReachabilityStatus __NS_SYMBOL(AA_AFStringFromNetworkReachabilityStatus)
#endif

#ifndef AA_AFQueryStringPairsFromDictionary
#define AA_AFQueryStringPairsFromDictionary __NS_SYMBOL(AA_AFQueryStringPairsFromDictionary)
#endif

#ifndef AA_AFQueryStringPairsFromKeyAndValue
#define AA_AFQueryStringPairsFromKeyAndValue __NS_SYMBOL(AA_AFQueryStringPairsFromKeyAndValue)
#endif

#ifndef AA_AFQueryStringPairsFromDictionary
#define AA_AFQueryStringPairsFromDictionary __NS_SYMBOL(AA_AFQueryStringPairsFromDictionary)
#endif

#ifndef AA_AFQueryStringPairsFromKeyAndValue
#define AA_AFQueryStringPairsFromKeyAndValue __NS_SYMBOL(AA_AFQueryStringPairsFromKeyAndValue)
#endif

// Externs
#ifndef AA_AFNetworkingReachabilityDidChangeNotification
#define AA_AFNetworkingReachabilityDidChangeNotification __NS_SYMBOL(AA_AFNetworkingReachabilityDidChangeNotification)
#endif

#ifndef AA_AFNetworkingReachabilityNotificationStatusItem
#define AA_AFNetworkingReachabilityNotificationStatusItem __NS_SYMBOL(AA_AFNetworkingReachabilityNotificationStatusItem)
#endif

#ifndef AA_AFURLResponseSerializationErrorDomain
#define AA_AFURLResponseSerializationErrorDomain __NS_SYMBOL(AA_AFURLResponseSerializationErrorDomain)
#endif

#ifndef AA_AFNetworkingOperationFailingURLResponseErrorKey
#define AA_AFNetworkingOperationFailingURLResponseErrorKey __NS_SYMBOL(AA_AFNetworkingOperationFailingURLResponseErrorKey)
#endif

#ifndef AA_AFNetworkingOperationFailingURLResponseDataErrorKey
#define AA_AFNetworkingOperationFailingURLResponseDataErrorKey __NS_SYMBOL(AA_AFNetworkingOperationFailingURLResponseDataErrorKey)
#endif

#ifndef AA_AFURLRequestSerializationErrorDomain
#define AA_AFURLRequestSerializationErrorDomain __NS_SYMBOL(AA_AFURLRequestSerializationErrorDomain)
#endif

#ifndef AA_AFNetworkingOperationFailingURLRequestErrorKey
#define AA_AFNetworkingOperationFailingURLRequestErrorKey __NS_SYMBOL(AA_AFNetworkingOperationFailingURLRequestErrorKey)
#endif

#ifndef AA_AFNetworkingTaskDidResumeNotification
#define AA_AFNetworkingTaskDidResumeNotification __NS_SYMBOL(AA_AFNetworkingTaskDidResumeNotification)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteNotification
#define AA_AFNetworkingTaskDidCompleteNotification __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteNotification)
#endif

#ifndef AA_AFNetworkingTaskDidSuspendNotification
#define AA_AFNetworkingTaskDidSuspendNotification __NS_SYMBOL(AA_AFNetworkingTaskDidSuspendNotification)
#endif

#ifndef AA_AFURLSessionDidInvalidateNotification
#define AA_AFURLSessionDidInvalidateNotification __NS_SYMBOL(AA_AFURLSessionDidInvalidateNotification)
#endif

#ifndef AA_AFURLSessionDownloadTaskDidFailToMoveFileNotification
#define AA_AFURLSessionDownloadTaskDidFailToMoveFileNotification __NS_SYMBOL(AA_AFURLSessionDownloadTaskDidFailToMoveFileNotification)
#endif

#ifndef AA_AFNetworkingTaskDidStartNotification
#define AA_AFNetworkingTaskDidStartNotification __NS_SYMBOL(AA_AFNetworkingTaskDidStartNotification)
#endif

#ifndef AA_AFNetworkingTaskDidFinishNotification
#define AA_AFNetworkingTaskDidFinishNotification __NS_SYMBOL(AA_AFNetworkingTaskDidFinishNotification)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteSerializedResponseKey
#define AA_AFNetworkingTaskDidCompleteSerializedResponseKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteSerializedResponseKey)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteResponseSerializerKey
#define AA_AFNetworkingTaskDidCompleteResponseSerializerKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteResponseSerializerKey)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteResponseDataKey
#define AA_AFNetworkingTaskDidCompleteResponseDataKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteResponseDataKey)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteErrorKey
#define AA_AFNetworkingTaskDidCompleteErrorKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteErrorKey)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteAssetPathKey
#define AA_AFNetworkingTaskDidCompleteAssetPathKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteAssetPathKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishSerializedResponseKey
#define AA_AFNetworkingTaskDidFinishSerializedResponseKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishSerializedResponseKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishResponseSerializerKey
#define AA_AFNetworkingTaskDidFinishResponseSerializerKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishResponseSerializerKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishResponseDataKey
#define AA_AFNetworkingTaskDidFinishResponseDataKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishResponseDataKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishErrorKey
#define AA_AFNetworkingTaskDidFinishErrorKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishErrorKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishAssetPathKey
#define AA_AFNetworkingTaskDidFinishAssetPathKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishAssetPathKey)
#endif

#ifndef AA_AFNetworkingOperationDidStartNotification
#define AA_AFNetworkingOperationDidStartNotification __NS_SYMBOL(AA_AFNetworkingOperationDidStartNotification)
#endif

#ifndef AA_AFNetworkingOperationDidFinishNotification
#define AA_AFNetworkingOperationDidFinishNotification __NS_SYMBOL(AA_AFNetworkingOperationDidFinishNotification)
#endif

#ifndef AA_kAFUploadStream3GSuggestedPacketSize
#define AA_kAFUploadStream3GSuggestedPacketSize __NS_SYMBOL(AA_kAFUploadStream3GSuggestedPacketSize)
#endif

#ifndef AA_kAFUploadStream3GSuggestedDelay
#define AA_kAFUploadStream3GSuggestedDelay __NS_SYMBOL(AA_kAFUploadStream3GSuggestedDelay)
#endif

#ifndef AA_AFNetworkingReachabilityDidChangeNotification
#define AA_AFNetworkingReachabilityDidChangeNotification __NS_SYMBOL(AA_AFNetworkingReachabilityDidChangeNotification)
#endif

#ifndef AA_AFNetworkingReachabilityNotificationStatusItem
#define AA_AFNetworkingReachabilityNotificationStatusItem __NS_SYMBOL(AA_AFNetworkingReachabilityNotificationStatusItem)
#endif

#ifndef AA_AFURLResponseSerializationErrorDomain
#define AA_AFURLResponseSerializationErrorDomain __NS_SYMBOL(AA_AFURLResponseSerializationErrorDomain)
#endif

#ifndef AA_AFNetworkingOperationFailingURLResponseErrorKey
#define AA_AFNetworkingOperationFailingURLResponseErrorKey __NS_SYMBOL(AA_AFNetworkingOperationFailingURLResponseErrorKey)
#endif

#ifndef AA_AFNetworkingOperationFailingURLResponseDataErrorKey
#define AA_AFNetworkingOperationFailingURLResponseDataErrorKey __NS_SYMBOL(AA_AFNetworkingOperationFailingURLResponseDataErrorKey)
#endif

#ifndef AA_AFNetworkingTaskDidResumeNotification
#define AA_AFNetworkingTaskDidResumeNotification __NS_SYMBOL(AA_AFNetworkingTaskDidResumeNotification)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteNotification
#define AA_AFNetworkingTaskDidCompleteNotification __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteNotification)
#endif

#ifndef AA_AFNetworkingTaskDidSuspendNotification
#define AA_AFNetworkingTaskDidSuspendNotification __NS_SYMBOL(AA_AFNetworkingTaskDidSuspendNotification)
#endif

#ifndef AA_AFURLSessionDidInvalidateNotification
#define AA_AFURLSessionDidInvalidateNotification __NS_SYMBOL(AA_AFURLSessionDidInvalidateNotification)
#endif

#ifndef AA_AFURLSessionDownloadTaskDidFailToMoveFileNotification
#define AA_AFURLSessionDownloadTaskDidFailToMoveFileNotification __NS_SYMBOL(AA_AFURLSessionDownloadTaskDidFailToMoveFileNotification)
#endif

#ifndef AA_AFNetworkingTaskDidStartNotification
#define AA_AFNetworkingTaskDidStartNotification __NS_SYMBOL(AA_AFNetworkingTaskDidStartNotification)
#endif

#ifndef AA_AFNetworkingTaskDidFinishNotification
#define AA_AFNetworkingTaskDidFinishNotification __NS_SYMBOL(AA_AFNetworkingTaskDidFinishNotification)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteSerializedResponseKey
#define AA_AFNetworkingTaskDidCompleteSerializedResponseKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteSerializedResponseKey)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteResponseSerializerKey
#define AA_AFNetworkingTaskDidCompleteResponseSerializerKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteResponseSerializerKey)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteResponseDataKey
#define AA_AFNetworkingTaskDidCompleteResponseDataKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteResponseDataKey)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteErrorKey
#define AA_AFNetworkingTaskDidCompleteErrorKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteErrorKey)
#endif

#ifndef AA_AFNetworkingTaskDidCompleteAssetPathKey
#define AA_AFNetworkingTaskDidCompleteAssetPathKey __NS_SYMBOL(AA_AFNetworkingTaskDidCompleteAssetPathKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishSerializedResponseKey
#define AA_AFNetworkingTaskDidFinishSerializedResponseKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishSerializedResponseKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishResponseSerializerKey
#define AA_AFNetworkingTaskDidFinishResponseSerializerKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishResponseSerializerKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishResponseDataKey
#define AA_AFNetworkingTaskDidFinishResponseDataKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishResponseDataKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishErrorKey
#define AA_AFNetworkingTaskDidFinishErrorKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishErrorKey)
#endif

#ifndef AA_AFNetworkingTaskDidFinishAssetPathKey
#define AA_AFNetworkingTaskDidFinishAssetPathKey __NS_SYMBOL(AA_AFNetworkingTaskDidFinishAssetPathKey)
#endif

#ifndef AA_AFURLRequestSerializationErrorDomain
#define AA_AFURLRequestSerializationErrorDomain __NS_SYMBOL(AA_AFURLRequestSerializationErrorDomain)
#endif

#ifndef AA_AFNetworkingOperationFailingURLRequestErrorKey
#define AA_AFNetworkingOperationFailingURLRequestErrorKey __NS_SYMBOL(AA_AFNetworkingOperationFailingURLRequestErrorKey)
#endif

#ifndef AA_AFNetworkingOperationDidStartNotification
#define AA_AFNetworkingOperationDidStartNotification __NS_SYMBOL(AA_AFNetworkingOperationDidStartNotification)
#endif

#ifndef AA_AFNetworkingOperationDidFinishNotification
#define AA_AFNetworkingOperationDidFinishNotification __NS_SYMBOL(AA_AFNetworkingOperationDidFinishNotification)
#endif

#ifndef AA_kAFUploadStream3GSuggestedPacketSize
#define AA_kAFUploadStream3GSuggestedPacketSize __NS_SYMBOL(AA_kAFUploadStream3GSuggestedPacketSize)
#endif

#ifndef AA_kAFUploadStream3GSuggestedDelay
#define AA_kAFUploadStream3GSuggestedDelay __NS_SYMBOL(AA_kAFUploadStream3GSuggestedDelay)
#endif

