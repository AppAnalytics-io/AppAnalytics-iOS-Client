#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GestureDetails : NSObject

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer;

- (NSString*)gestureTypeName;

- (BOOL)isTap;
- (BOOL)isDoubleTap;
- (BOOL)isTripleTap;
- (BOOL)isLongTap;
- (BOOL)isSwipe;

@end