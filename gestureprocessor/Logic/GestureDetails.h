#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GestureDetails : NSObject

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer;

- (NSString*)gestureTypeName;
- (NSString*)info;

- (BOOL)isTap;
- (BOOL)isSingleTap;
- (BOOL)isDoubleTap;
- (BOOL)isTripleTap;
- (BOOL)isLongTap;
- (BOOL)isPinch;
- (BOOL)isRotate;
- (BOOL)isSwipe;

@end
