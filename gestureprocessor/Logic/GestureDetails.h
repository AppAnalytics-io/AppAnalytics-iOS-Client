#import <Foundation/Foundation.h>
#import "LogInfoProtocol.h"

@interface GestureDetails : NSObject <LogInfo>

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer;

- (BOOL)isTap;
- (BOOL)isSingleTap;
- (BOOL)isDoubleTap;
- (BOOL)isTripleTap;
- (BOOL)isLongTap;
- (BOOL)isPinch;
- (BOOL)isRotate;
- (BOOL)isSwipe;

@end
