#import "UIWindow+Tracking.h"
#import <objc/runtime.h>
#import "GestureTracker.h"
#import "NSObject+Swizzling.h"
#import "KeyboardWatcher.h"

@implementation UIWindow (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(initWithFrame:)
                               with:@selector(initWithFrameSwizzled:)];
    });
}

- (instancetype)initWithFrameSwizzled:(CGRect)frame
{
    self = [self initWithFrameSwizzled:frame];
    if (self)
    {
        [[GestureTracker instance] trackWindowGestures:self];
        [KeyboardWatcher instance];
    }
    return self;
}

@end
