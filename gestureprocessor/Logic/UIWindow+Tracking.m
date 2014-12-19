#import "UIWindow+Tracking.h"
#import <objc/runtime.h>
#import "GestureTracker.h"

@implementation UIWindow (Tracking)

#pragma mark - Life Cycle

- (instancetype)initWithFrameSwizzled:(CGRect)frame
{
    self = [self initWithFrameSwizzled:frame];
    if (self)
    {
        [[GestureTracker instance] trackWindowGestures:self];
    }
    return self;
}

#pragma mark - Swizzling

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(initWithFrame:)
                               with:@selector(initWithFrameSwizzled:)];
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

@end
