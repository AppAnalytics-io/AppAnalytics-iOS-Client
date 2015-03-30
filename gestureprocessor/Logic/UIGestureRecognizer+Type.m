#import "UIGestureRecognizer+Type.h"

@implementation UIGestureRecognizer (Type)

#pragma mark - Obtain App Analytics Action Type From UIGestureRecognizer

- (ActionType)actionType
{
    ActionType type = ActionType_Unknown;
    if (self.isSingleTap)
    {
        type = [UIGestureRecognizer singleTapActionTypeWithTouchesCount:self.numberOfTouches];
    }
    else if (self.isDoubleTap)
    {
        type = [UIGestureRecognizer doubleTapActionTypeWithTouchesCount:self.numberOfTouches];
    }
    else if (self.isTripleTap)
    {
        type = [UIGestureRecognizer tripleTapActionTypeWithTouchesCount:self.numberOfTouches];
    }
    else if (self.isLongTap)
    {
        type = [UIGestureRecognizer longPressActionTypeWithTouchesCount:self.numberOfTouches];
    }
    else if (self.isPinch)
    {
        type = ActionType_PinchWith2Finger;
    }
    else if (self.isRotate)
    {
        type = ActionType_RotateWith2Finger;
    }
    else if (self.isSwipe)
    {
        type = [UIGestureRecognizer
                swipeActionTypeWithTouchesCount:self.numberOfTouches
                direction:((UISwipeGestureRecognizer*)self).direction];
    }
    return type;
}

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

+ (ActionType)singleTapActionTypeWithTouchesCount:(NSUInteger)count
{
    ActionType action;
    switch (count)
    {
        case 0:
            action = ActionType_Unknown;
            break;
        case 1:
            action = ActionType_SingleTapWith1Finger;
            break;
        case 2:
            action = ActionType_SingleTapWith2Finger;
            break;
        case 3:
            action = ActionType_SingleTapWith3Finger;
            break;
        case 4:
            action = ActionType_SingleTapWith4Finger;
            break;
        default:
            action = ActionType_SingleTapWith4Finger;
            break;
    }
    return action;
}

+ (ActionType)doubleTapActionTypeWithTouchesCount:(NSUInteger)count
{
    ActionType action;
    switch (count)
    {
        case 0:
            action = ActionType_Unknown;
            break;
        case 1:
            action = ActionType_DoubleTapWith1Finger;
            break;
        case 2:
            action = ActionType_DoubleTapWith2Finger;
            break;
        case 3:
            action = ActionType_DoubleTapWith3Finger;
            break;
        case 4:
            action = ActionType_DoubleTapWith4Finger;
            break;
        default:
            action = ActionType_DoubleTapWith4Finger;
            break;
    }
    return action;
}

+ (ActionType)tripleTapActionTypeWithTouchesCount:(NSUInteger)count
{
    ActionType action;
    switch (count)
    {
        case 0:
            action = ActionType_Unknown;
            break;
        case 1:
            action = ActionType_TripleTapWith1Finger;
            break;
        case 2:
            action = ActionType_TripleTapWith2Finger;
            break;
        case 3:
            action = ActionType_TripleTapWith3Finger;
            break;
        case 4:
            action = ActionType_TripleTapWith4Finger;
            break;
        default:
            action = ActionType_TripleTapWith4Finger;
            break;
    }
    return action;
}

+ (ActionType)longPressActionTypeWithTouchesCount:(NSUInteger)count
{
    ActionType action;
    switch (count)
    {
        case 0:
            action = ActionType_Unknown;
            break;
        case 1:
            action = ActionType_LongPressWith1Finger;
            break;
        case 2:
            action = ActionType_LongPressWith2Finger;
            break;
        case 3:
            action = ActionType_LongPressWith3Finger;
            break;
        case 4:
            action = ActionType_LongPressWith4Finger;
            break;
        default:
            action = ActionType_LongPressWith4Finger;
            break;
    }
    return count;
}

+ (ActionType)swipeActionTypeWithTouchesCount:(NSUInteger)count
                                    direction:(UISwipeGestureRecognizerDirection)direction
{
    ActionType action = ActionType_Unknown;
    
    if (direction == UISwipeGestureRecognizerDirectionLeft)
    {
        switch (count)
        {
            case 0:
                action = ActionType_Unknown;
                break;
            case 1:
                action = ActionType_SwipeLeftWith1Finger;
                break;
            case 2:
                action = ActionType_SwipeLeftWith2Finger;
                break;
            case 3:
                action = ActionType_SwipeLeftWith3Finger;
                break;
            case 4:
                action = ActionType_SwipeLeftWith4Finger;
                break;
            default:
                action = ActionType_SwipeLeftWith4Finger;
                break;
        }
    }
    else if (direction == UISwipeGestureRecognizerDirectionRight)
    {
        switch (count)
        {
            case 0:
                action = ActionType_Unknown;
                break;
            case 1:
                action = ActionType_SwipeRightWith1Finger;
                break;
            case 2:
                action = ActionType_SwipeRightWith2Finger;
                break;
            case 3:
                action = ActionType_SwipeRightWith3Finger;
                break;
            case 4:
                action = ActionType_SwipeRightWith4Finger;
                break;
            default:
                action = ActionType_SwipeRightWith4Finger;
                break;
        }
    }
    else if (direction == UISwipeGestureRecognizerDirectionUp)
    {
        switch (count)
        {
            case 0:
                action = ActionType_Unknown;
                break;
            case 1:
                action = ActionType_SwipeUpWith1Finger;
                break;
            case 2:
                action = ActionType_SwipeUpWith2Finger;
                break;
            case 3:
                action = ActionType_SwipeUpWith3Finger;
                break;
            case 4:
                action = ActionType_SwipeUpWith4Finger;
                break;
            default:
                action = ActionType_SwipeUpWith4Finger;
                break;
        }
    }
    else if (direction == UISwipeGestureRecognizerDirectionDown)
    {
        switch (count)
        {
            case 0:
                action = ActionType_Unknown;
                break;
            case 1:
                action = ActionType_SwipeDownWith1Finger;
                break;
            case 2:
                action = ActionType_SwipeDownWith2Finger;
                break;
            case 3:
                action = ActionType_SwipeDownWith3Finger;
                break;
            case 4:
                action = ActionType_SwipeDownWith4Finger;
                break;
            default:
                action = ActionType_SwipeDownWith4Finger;
                break;
        }
    }
    
    return action;
}

@end
