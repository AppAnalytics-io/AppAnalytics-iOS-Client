#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AppAnalytics.h"

@interface EventsObserver : NSObject <SKPaymentTransactionObserver>

+ (instancetype)instance;

@end
