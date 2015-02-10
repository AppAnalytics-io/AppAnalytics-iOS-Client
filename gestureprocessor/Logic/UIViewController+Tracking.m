#import "UIViewController+Tracking.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
#import "Logger.h"

@implementation UIViewController (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(viewWillAppear:)
                               with:@selector(viewWillAppearSwizzled:)];
    });
}

- (void)viewWillAppearSwizzled:(BOOL)animated
{
    [self viewWillAppearSwizzled:animated];
    static NSString* omittedClass = @"UIInputWindowController";
    NSString* className = NSStringFromClass(self.class);
    if (![className isEqualToString:omittedClass])
    {
        [[Logger instance] navigationRecognizedWithViewControllerID:NSStringFromClass(self.class)];
    }
}

@end
