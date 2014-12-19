#import "UISwipeGestureRecognizer+DirectionString.h"

@implementation UISwipeGestureRecognizer (DirectionString)

- (NSString*)directionText
{
    switch (self.direction)
    {
        case UISwipeGestureRecognizerDirectionLeft:
            return @"Left";
            break;
        case UISwipeGestureRecognizerDirectionRight:
            return @"Right";
            break;
        case UISwipeGestureRecognizerDirectionUp:
            return @"Up";
            break;
        case UISwipeGestureRecognizerDirectionDown:
            return @"Down";
            break;
    }
}

@end
