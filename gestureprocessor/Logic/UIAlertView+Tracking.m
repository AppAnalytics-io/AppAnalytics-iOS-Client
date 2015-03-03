#import "UIAlertView+Tracking.h"
#import "NSObject+Swizzling.h"
#import "AppAnalytics.h"
#import "GTConstants.h"

@implementation UIAlertView (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(show)
                               with:@selector(showSwizzled)];
    });
}

- (void)showSwizzled
{
    [self showSwizzled];
    NSString* title = self.title ? self.title : kEmptyParameter;
    NSString* message = self.message ? self.message : kEmptyParameter;
    [AppAnalytics logEvent:kAlertEvent parameters:@{kAlertTitle : title, kAlertMessage : message}];
}

@end
