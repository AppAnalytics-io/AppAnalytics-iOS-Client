#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AppAnalytics.h"

@interface AAEventsObserver : NSObject <SKPaymentTransactionObserver>

+ (instancetype)instance;

@end
