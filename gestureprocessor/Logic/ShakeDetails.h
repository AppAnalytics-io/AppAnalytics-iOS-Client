#import <Foundation/Foundation.h>
#import "LogInfoProtocol.h"

@interface ShakeDetails : NSObject <LogInfo>

- (instancetype)initWithIndex:(NSUInteger)index;

@end
