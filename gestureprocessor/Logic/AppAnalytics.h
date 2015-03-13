#import <Foundation/Foundation.h>

@interface AppAnalytics : NSObject

+ (void)initWithAppKey:(NSString*)appKey;

+ (void)logEvent:(NSString*)description;

+ (void)logEvent:(NSString*)description parameters:(NSDictionary*)parameters;

+ (void)setDispatchInverval:(NSTimeInterval)dispatchInterval;

+ (void)setDebugLogEnabled:(BOOL)enabled;

+ (void)setExceptionAnalyticsEnabled:(BOOL)enabled;

+ (void)setTransactionAnalyticsEnabled:(BOOL)enabled;

+ (void)setNavigationAnalyticsEnabled:(BOOL)enabled;

+ (void)setPopUpsAnalyticsEnabled:(BOOL)enabled;

@end
