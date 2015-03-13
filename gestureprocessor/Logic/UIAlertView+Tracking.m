#import "UIAlertView+Tracking.h"
#import "NSObject+Swizzling.h"
#import "AppAnalytics.h"
#import "GTConstants.h"
#import "EventsManager.h"

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
    if ([EventsManager instance].popupAnalyticEnabled)
    {
        NSString* title = self.title ? self.title : kNullParameter;
        NSString* message = self.message ? self.message : kNullParameter;
        [AppAnalytics logEvent:kAlertEvent parameters:@{kAlertTitle : title, kAlertMessage : message}];
    }
}

@end
