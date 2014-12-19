#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GestureDetails;

@interface Logger : NSObject

+ (instancetype)instance;
- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer;
- (void)shakeRecognized;

@property (nonatomic, strong, readonly) NSMutableArray* actions;

@end
