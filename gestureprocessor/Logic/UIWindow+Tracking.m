#import "UIWindow+Tracking.h"
#import <objc/runtime.h>
#import "GestureTracker.h"
#import "NSObject+Swizzling.h"

@interface GestureTracker (Tracking)

+ (instancetype)instance;
- (void)trackWindowGestures:(UIWindow*)window;

@end

@implementation UIWindow (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(init)
                               with:@selector(initSwizzled)];
        
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
    }
    return self;
}

- (instancetype)initSwizzled
{
    self = [self initSwizzled];
    if (self)
    {
        [[GestureTracker instance] trackWindowGestures:self];
    }
    return self;
}

@end
