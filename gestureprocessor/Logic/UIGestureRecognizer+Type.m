#import "UIGestureRecognizer+Type.h"

@implementation UIGestureRecognizer (Type)

- (BOOL)isTap
{
    return [self checkGestureClass:[UITapGestureRecognizer class]];
}

- (BOOL)isSingleTap
{
    return [self checkTapGestureRequiresTaps:1];
}

- (BOOL)isDoubleTap
{
    return [self checkTapGestureRequiresTaps:2];
}

- (BOOL)isTripleTap
{
    return [self checkTapGestureRequiresTaps:3];
}

- (BOOL)isLongTap
{
    return [self checkGestureClass:[UILongPressGestureRecognizer class]];
}

- (BOOL)isPinch
{
    return [self checkGestureClass:[UIPinchGestureRecognizer class]];
}

- (BOOL)isRotate
{
    return [self checkGestureClass:[UIRotationGestureRecognizer class]];
}

- (BOOL)isSwipe
{
    return [self checkGestureClass:[UISwipeGestureRecognizer class]];
}

- (BOOL)checkTapGestureRequiresTaps:(NSUInteger)numberOfTaps
{
    if ([self checkGestureClass:[UITapGestureRecognizer class]])
    {
        UITapGestureRecognizer* tap = (UITapGestureRecognizer*) self;
        return tap.numberOfTapsRequired == numberOfTaps;
    }
    return NO;
}

- (BOOL)checkGestureClass:(Class)class
{
    return [self isKindOfClass:class];
}

@end
