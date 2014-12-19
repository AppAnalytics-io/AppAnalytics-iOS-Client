#import "UIResponder+Tracking.h"
#import <objc/runtime.h>
#import "GestureTracker.h"

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

+ (void)swizzleOriginalMethod:(SEL)originalSelector with:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)motionEndedSwizzled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self motionEndedSwizzled:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake)
    {
        [[GestureTracker instance] onShake];
    }
}

@end
