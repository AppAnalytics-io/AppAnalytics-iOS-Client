#import "GestureProcessorHelpers.h"
#import "KeyboardWatcher.h"

@implementation GestureProcessorHelpers

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

+ (BOOL)isNavigationBarPressed:(CGPoint)touchPosition
{
    UIViewController* topVC = [self topViewController];
    UIViewController* parentVC = topVC.parentViewController;
    
    if ([parentVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navController = (UINavigationController*) parentVC;
        CGRect navBarFrame = navController.navigationBar.frame;
        if (CGRectContainsPoint(navBarFrame, touchPosition))
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isToolBarPressed:(CGPoint)touchPosition
{
    UIViewController* topVC = [self topViewController];
    UIViewController* parentVC = topVC.parentViewController;
    
    if ([parentVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navController = (UINavigationController*) parentVC;
        CGRect toolBarFrame = navController.toolbar.frame;
        if (CGRectContainsPoint(toolBarFrame, touchPosition))
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
    else if ([self isNavigationBarPressed:position])
    {
        return @"Navigation Bar";
    }
    else if ([self isToolBarPressed:position])
    {
        return @"Tool Bar";
    }
    
    UIView* targetView = rootView;
    for (UIView* view in rootView.subviews)
    {
        if (CGRectContainsPoint(view.frame, position) && !view.hidden)
        {
            targetView = view;
        }
    }
    
    return NSStringFromClass([targetView class]);
}

+ (Version)appVersion
{
    NSString *majorAndMinorVersions = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSArray* versionComponents = [majorAndMinorVersions componentsSeparatedByString:@"."];
    
    Version version;
    version.major = (UInt32)((versionComponents.count > 0) ? [versionComponents.firstObject integerValue] : 0);
    version.minor = (UInt32)((versionComponents.count > 1) ? [versionComponents.lastObject integerValue] : 0);
    version.build = (UInt32)((buildVersion != nil) ? [buildVersion integerValue] : 0);
    version.revision = 0;
    
    return version;
}

+ (Version)OSVersion
{
    NSArray *versionComponents = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    
    Version version;
    
    version.major =     (UInt32)((versionComponents.count > 0) ? [versionComponents[0] integerValue] : 0);
    version.minor =     (UInt32)((versionComponents.count > 1) ? [versionComponents[1] integerValue] : 0);
    version.build =     (UInt32)((versionComponents.count > 2) ? [versionComponents[2] integerValue] : 0);
    version.revision =  (UInt32)((versionComponents.count > 3) ? [versionComponents[3] integerValue] : 0);
    
    return version;
}

+ (CGSize)screenSizeInPixels
{
    return CGSizeMake([UIScreen mainScreen].scale * [UIScreen mainScreen].bounds.size.width,
                      [UIScreen mainScreen].scale * [UIScreen mainScreen].bounds.size.height);
}

+ (void)checkAppKey:(NSString *)appKey
{
    if (!appKey || !appKey.length)
    {
        [[NSException exceptionWithName:@"Gesture Processor Exception"
                                 reason:@"Incorrect App Key"
                               userInfo:nil]
         raise];
    }
}

@end