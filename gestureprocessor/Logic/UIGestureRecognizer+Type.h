#import <UIKit/UIKit.h>
#import "LogInfoProtocol.h"

@interface UIGestureRecognizer (Type)

- (ActionType)actionType;

- (BOOL)isTap;
- (BOOL)isSingleTap;
- (BOOL)isDoubleTap;
- (BOOL)isTripleTap;
- (BOOL)isLongTap;
- (BOOL)isPinch;
- (BOOL)isRotate;
- (BOOL)isSwipe;

+ (ActionType)singleTapActionTypeWithTouchesCount:(NSUInteger)count;
+ (ActionType)doubleTapActionTypeWithTouchesCount:(NSUInteger)count;
+ (ActionType)tripleTapActionTypeWithTouchesCount:(NSUInteger)count;
+ (ActionType)longPressActionTypeWithTouchesCount:(NSUInteger)count;
+ (ActionType)swipeActionTypeWithTouchesCount:(NSUInteger)count
                                    direction:(UISwipeGestureRecognizerDirection)direction;
@end
