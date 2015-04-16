#import "UIViewController+Tracking.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
#import "AALogger.h"
#import "AppAnalytics.h"
#import "GTConstants.h"
#import "AAEventsManager.h"

@interface AppAnalytics (AnalyticsEnabled)

+ (instancetype)instance;
@property (nonatomic, readonly) BOOL heatMapAnalyticsEnabled;

@end

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
        if ([AppAnalytics instance].heatMapAnalyticsEnabled)
        {
            [[AALogger instance] navigationRecognizedWithViewControllerID:NSStringFromClass(self.class)];
        }
        
        if ([AAEventsManager instance].screenAnalyticEnabled)
        {
            [AppAnalytics logEvent:kNavigationEvent parameters:@{kNavigationEventClassName : className}];
        }
    }
}

@end
