#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct _Version
{
    UInt32 major;
    UInt32 minor;
    UInt32 build;
    UInt32 revision;
} Version;

@interface GestureProcessorHelpers : NSObject

+ (NSString*)topViewControllerClassName;
+ (UIViewController*)topViewController;
+ (NSString*)subviewClassNameAtPosition:(CGPoint)position ofView:(UIView*)rootView;
+ (Version)appVersion;
+ (Version)OSVersion;
+ (CGSize)screenSizeInPixels;

@end
