#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface EventsManager : NSObject <SKPaymentTransactionObserver>

+ (instancetype)instance;

- (void)addEvent:(NSString*)description;

- (void)addEvent:(NSString*)description parameters:(NSDictionary*)parameters;

- (void)handleUncaughtException:(NSException*)exception;

@property (nonatomic, readonly) NSTimeInterval dispatchInterval;
@property (nonatomic, readonly) BOOL debugLogEnabled;

@end
