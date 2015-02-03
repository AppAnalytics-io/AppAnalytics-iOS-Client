#import "UIWindow+Tracking.h"
#import <objc/runtime.h>
#import "AppAnalytics.h"
#import "NSObject+Swizzling.h"

@interface AppAnalytics (Tracking)

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
        [[AppAnalytics instance] trackWindowGestures:self];
    }
    return self;
}

- (instancetype)initSwizzled
{
    self = [self initSwizzled];
    if (self)
    {
        [[AppAnalytics instance] trackWindowGestures:self];
    }
    return self;
}

@end
