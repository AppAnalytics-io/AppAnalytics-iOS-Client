#import <Foundation/Foundation.h>

@interface EventsManager : NSObject

+ (instancetype)instance;

- (void)addEvent:(NSString*)description async:(BOOL)asynch;

- (void)addEvent:(NSString *)description parameters:(NSDictionary *)parameters async:(BOOL)asynch;

- (void)handleUncaughtException:(NSException*)exception;

@property (nonatomic, readonly) BOOL popupAnalyticEnabled;
@property (nonatomic, readonly) BOOL transactionAnalyticEnabled;

@end
