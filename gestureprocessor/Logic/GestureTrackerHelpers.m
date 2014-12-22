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

+ (NSString*)subviewClassNameAtPosition:(CGPoint)position ofView:(UIView*)rootView
{
    if ([KeyboardWatcher instance].isKeyboardShown)
    {
        if (CGRectContainsPoint([KeyboardWatcher instance].keyboardFrame, position))
        {
            return @"Keyboard";
        }
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

#if 0
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
