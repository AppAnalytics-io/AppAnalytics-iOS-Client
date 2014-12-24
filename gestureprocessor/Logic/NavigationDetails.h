#import <Foundation/Foundation.h>
#import "LogInfoProtocol.h"

@interface NavigationDetails : NSObject <LogInfo>

- (instancetype)initWithIndex:(NSUInteger)index triggerViewControllerID:(NSString*)triggerVcID;

@end
