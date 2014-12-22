#import "GestureTrackerHelpers.h"
#import "KeyboardWatcher.h"

@implementation GestureTrackerHelpers

+ (UIViewController*)topViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([topController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navCon = (UINavigationController*) topController;
        topController = navCon.viewControllers.lastObject;
    }
    else if ([topController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabCon = (UITabBarController*) topController;
        topController = tabCon.selectedViewController;
    }
    
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
        
        if ([topController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController* navCon = (UINavigationController*) topController;
            topController = navCon.viewControllers.lastObject;
        }
        else if ([topController isKindOfClass:[UITabBarController class]])
        {
            UITabBarController* tabCon = (UITabBarController*) topController;
            topController = tabCon.selectedViewController;
        }
    }
    
    return topController;
}

+ (NSString*)topViewControllerClassName
{
    UIViewController* topViewController = [self topViewController];
    NSString* className = NSStringFromClass([topViewController class]);
    return className;
}

+ (BOOL)isKeyboardPressed:(CGPoint)touchPosition
{
    if ([KeyboardWatcher instance].isKeyboardShown)
    {
        if (CGRectContainsPoint([KeyboardWatcher instance].keyboardFrame, touchPosition))
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isTabBarPressed:(CGPoint)touchPosition
{
    UIViewController* topVC = [self topViewController];
    UIViewController* parentVC = topVC.parentViewController;
    
    if ([parentVC isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabController = (UITabBarController*) parentVC;
        CGRect tabBarFrame = tabController.tabBar.frame;
        if (CGRectContainsPoint(tabBarFrame, touchPosition))
        {
            return YES;
        }
    }
    return NO;
}

+ (NSString*)subviewClassNameAtPosition:(CGPoint)position ofView:(UIView*)rootView
{
    if ([self isKeyboardPressed:position])
    {
        return @"Keyboard";
    }
    else if ([self isTabBarPressed:position])
    {
        return @"TabBarItem";
    }
    
    UIView* targetView = nil;
    for (UIView* view in rootView.subviews)
    {
        if (CGRectContainsPoint(view.frame, position))
        {
            targetView = view;
        }
    }
    
    return NSStringFromClass([targetView class]);
}

#if 0 // get the most underlying subview. not required yet
+ (UIView*)subviewAtPosition:(CGPoint)position ofView:(UIView*)rootView
{
    UIView* targetView = nil;
    for (UIView* view in rootView.subviews)
    {
        if (CGRectContainsPoint(view.frame, position))
        {
            targetView = view;
            if (targetView.subviews)
            {
                [self subviewAtPosition:[targetView convertPoint:position fromView:rootView] ofView:targetView];
            }
            else
            {
                break;
            }
        }
    }
    return targetView;
}
#endif

@end
