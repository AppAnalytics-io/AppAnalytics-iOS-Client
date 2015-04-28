#import <Foundation/Foundation.h>
#import "LogInfo.h"

@interface AAGestureDetails : LogObject

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
                                    index:(NSUInteger)index;

- (instancetype)initWithType:(ActionType)type
             triggerPosition:(CGPoint)position
               triggerViewID:(NSString*)viewID
                       index:(NSUInteger)index;

@end
