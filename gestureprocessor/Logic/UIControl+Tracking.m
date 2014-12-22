#import "UIControl+Tracking.h"
#import "NSObject+Swizzling.h"
#import "Logger.h"

@implementation UIControl (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(touchesBegan:withEvent:)
                               with:@selector(touchesBeganSwizzled:withEvent:)];
        
        [self swizzleOriginalMethod:@selector(touchesEnded:withEvent:)
                               with:@selector(touchesEndedSwizzled:withEvent:)];
    });
}

- (void)touchesBeganSwizzled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBeganSwizzled:touches withEvent:event];
}

- (void)touchesEndedSwizzled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEndedSwizzled:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    
    [[Logger instance] gestureRecognized:ActionType_SingleTap
                         triggerPosition:[touch locationInView:nil]
                           triggerViewID:NSStringFromClass([self class])];
}

@end
