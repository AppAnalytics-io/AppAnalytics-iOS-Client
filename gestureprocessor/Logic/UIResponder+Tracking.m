#import "UIResponder+Tracking.h"
#import <objc/runtime.h>
#import "GestureProcessor.h"
#import "NSObject+Swizzling.h"

@interface GestureProcessor (Shake)

+ (instancetype)instance;
- (void)onShake;

@end

@implementation UIResponder (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(motionEnded:withEvent:)
                               with:@selector(motionEndedSwizzled:withEvent:)];
    });
}

- (void)motionEndedSwizzled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self motionEndedSwizzled:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake)
    {
        [[GestureProcessor instance] onShake];
    }
}

@end
