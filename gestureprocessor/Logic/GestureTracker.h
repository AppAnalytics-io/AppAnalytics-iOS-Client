#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GestureTracker : NSObject

+ (instancetype)instance;
- (void)trackWindowGestures:(UIWindow*)window;
- (void)onShake;

@end
