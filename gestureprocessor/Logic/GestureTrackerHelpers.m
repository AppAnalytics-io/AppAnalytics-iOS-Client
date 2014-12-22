#import "GestureTrackerHelpers.h"

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

@end
