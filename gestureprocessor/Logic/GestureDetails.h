#import <Foundation/Foundation.h>
#import "LogInfoProtocol.h"

@interface GestureDetails : NSObject <LogInfo>

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
                                    index:(NSUInteger)index;

- (instancetype)initWithType:(ActionType)type
             triggerPosition:(CGPoint)position
               triggerViewID:(NSString*)viewID
                       index:(NSUInteger)index;

@end
