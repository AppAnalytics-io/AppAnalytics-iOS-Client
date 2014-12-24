#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LogInfoProtocol.h"

@class GestureDetails;

@interface Logger : NSObject

+ (instancetype)instance;

- (void)createSessionManifest;

- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer;

- (void)gestureRecognized:(ActionType)type
          triggerPosition:(CGPoint)position
            triggerViewID:(NSString*)viewID;

- (void)navigationRecognizedWithViewControllerID:(NSString*)viewControllerID;

- (void)shakeRecognized;

@end
