#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (Type)

- (BOOL)isTap;
- (BOOL)isSingleTap;
- (BOOL)isDoubleTap;
- (BOOL)isTripleTap;
- (BOOL)isLongTap;
- (BOOL)isPinch;
- (BOOL)isRotate;
- (BOOL)isSwipe;

@end
