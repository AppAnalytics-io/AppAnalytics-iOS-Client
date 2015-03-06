#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface EventsManager : NSObject <SKPaymentTransactionObserver>

+ (instancetype)instance;

- (void)addEvent:(NSString*)description asynch:(BOOL)asynch;

- (void)addEvent:(NSString *)description parameters:(NSDictionary *)parameters asynch:(BOOL)asynch;

- (void)handleUncaughtException:(NSException*)exception;

@end
