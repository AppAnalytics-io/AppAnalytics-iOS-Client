#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LogInfo.h"

@class GestureDetails;
@class Event;

@interface Logger : NSObject

+ (instancetype)instance;

- (void)createSessionManifest;

- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer;

- (void)gestureRecognized:(ActionType)type
          triggerPosition:(CGPoint)position
            triggerViewID:(NSString*)viewID;

- (void)navigationRecognizedWithViewControllerID:(NSString*)viewControllerID;

- (void)shakeRecognized;

- (void)debugLogEvent:(Event*)event;

@property (nonatomic, readonly) BOOL isManifestSent;

@end
