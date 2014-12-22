#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GestureTrackerHelpers : NSObject

+ (NSString*)topViewControllerClassName;
+ (UIViewController*)topViewController;
+ (NSString*)subviewClassNameAtPosition:(CGPoint)position ofView:(UIView*)rootView;

@end
