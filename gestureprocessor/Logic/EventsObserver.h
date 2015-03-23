#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface EventsObserver : NSObject <SKPaymentTransactionObserver>

+ (instancetype)instance;

@end
