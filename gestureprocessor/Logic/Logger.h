#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GestureDetails;

@interface Logger : NSObject

+ (instancetype)instance;
- (void)gestureRecognized:(UIGestureRecognizer*)gestureRecognizer;

@property (nonatomic, strong, readonly) NSMutableArray* gestures;

@end
