#import <Foundation/Foundation.h>
#import "LogInfo.h"

@interface NavigationDetails : LogObject

- (instancetype)initWithIndex:(NSUInteger)index triggerViewControllerID:(NSString*)triggerVcID;

@end
