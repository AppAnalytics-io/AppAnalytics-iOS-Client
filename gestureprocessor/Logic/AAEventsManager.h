#import <Foundation/Foundation.h>

@interface AAEventsManager : NSObject

+ (instancetype)instance;

- (void)addEvent:(NSString*)description async:(BOOL)asynch;

- (void)addEvent:(NSString *)description parameters:(NSDictionary *)parameters async:(BOOL)asynch;

- (void)handleUncaughtException:(NSException*)exception;

@property (nonatomic, readonly) BOOL screenAnalyticEnabled;
@property (nonatomic, readonly) BOOL popupAnalyticEnabled;
@property (nonatomic, readonly) BOOL transactionAnalyticEnabled;
@property (nonatomic, readonly) BOOL locationServicesAnalyticEnabled;
@property (nonatomic, readonly) BOOL connectionAnalyticEnabled;
@property (nonatomic, readonly) BOOL applicationStateAnalyticEnabled;
@property (nonatomic, readonly) BOOL deviceOrientationAnalyticEnabled;
@property (nonatomic, readonly) BOOL batteryAnalyticEnabled;
@property (nonatomic, readonly) BOOL keyboardAnalyticsEnabled;

@end
