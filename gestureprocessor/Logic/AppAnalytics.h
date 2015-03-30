#import <Foundation/Foundation.h>

/* Generate debug logs to console */
extern NSString* const DebugLog;

extern NSString* const HeatMapAnalytics;

extern NSString* const ExceptionAnalytics;

extern NSString* const TransactionAnalytics;

extern NSString* const PopUpAnalytics;

extern NSString* const MotionAnalytics;

extern NSString* const LocationServicesAnalytics;

extern NSString* const ConnectionAnalytics;

extern NSString* const ApplicationStateAnalytics;

extern NSString* const DeviceOrientationAnalytics;

extern NSString* const BatteryAnalytics;


@interface AppAnalytics : NSObject

+ (void)initWithAppKey:(NSString*)appKey;

+ (void)initWithAppKey:(NSString *)appKey options:(NSDictionary*)options;

+ (void)logEvent:(NSString*)description;

+ (void)logEvent:(NSString*)description parameters:(NSDictionary*)parameters;

+ (void)setDispatchInverval:(NSTimeInterval)dispatchInterval;

+ (void)setDebugLogEnabled:(BOOL)enabled;

+ (void)setExceptionAnalyticsEnabled:(BOOL)enabled;

+ (void)setTransactionAnalyticsEnabled:(BOOL)enabled;

+ (void)setNavigationAnalyticsEnabled:(BOOL)enabled;

+ (void)setPopUpsAnalyticsEnabled:(BOOL)enabled;

+ (void)setMotionAnalyticsEnabled:(BOOL)enabled;

+ (void)setLocationServicesAnalyticsEnabled:(BOOL)enabled;

+ (void)setConnectionAnalyticsEnabled:(BOOL)enabled;

+ (void)setApplicationStateAnalyticsEnabled:(BOOL)enabled;

+ (void)setDeviceOrientationAnalyticsEnabled:(BOOL)enabled;

+ (void)setBatteryAnalyticsEnabled:(BOOL)enabled;

+ (void)setHeatMapAnalyticsEnabled:(BOOL)enabled;

@end