#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LogInfo.h"

@class AAGestureDetails;
@class AAEvent;

@interface AALogger : NSObject

+ (instancetype)instance;

- (void)createSessionManifest;

- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer;

- (void)gestureRecognized:(ActionType)type
          triggerPosition:(CGPoint)position
            triggerViewID:(NSString*)viewID;

- (void)navigationRecognizedWithViewControllerID:(NSString*)viewControllerID;

- (void)shakeRecognized;

- (void)debugLogEvent:(AAEvent*)event;

@property (nonatomic, readonly) BOOL isManifestSent;

@end
