#import "UISegmentedControl+Tracking.h"
#import "NSObject+Swizzling.h"
#import "AALogger.h"
#import "UIGestureRecognizer+Type.h"

@implementation UISegmentedControl (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(touchesEnded:withEvent:)
                               with:@selector(touchesEndedSwizzled:withEvent:)];
    });
}

- (void)touchesEndedSwizzled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEndedSwizzled:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    
    [[AALogger instance] gestureRecognized:[UIGestureRecognizer singleTapActionTypeWithTouchesCount:touches.count]
                         triggerPosition:[touch locationInView:nil]
                           triggerViewID:NSStringFromClass([self class])];
}

@end
