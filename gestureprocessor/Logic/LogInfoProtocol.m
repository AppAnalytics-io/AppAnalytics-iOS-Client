#import "LogInfoProtocol.h"

NSString* NSStringWithActionType(ActionType input)
{
    NSArray *arr = @[
                     @"Unknown",
                     @"Single Tap",
                     @"Double Tap",
                     @"Triple Tap",
                     @"Long Tap",
                     @"Pinch",
                     @"Rotate",
                     @"Swipe",
                     @"Shake"
                     ];
    return (NSString *) arr[input];
}
