#import "LogInfoProtocol.h"

NSString* NSStringWithActionType(ActionType input)
{
    NSArray *arr = @[
                     @"Unknown",
                     @"SingleTap",
                     @"DoubleTap",
                     @"TripleTap",
                     @"LongTap",
                     @"Pinch",
                     @"Rotate",
                     @"Swipe",
                     @"Shake"
                     ];
    return (NSString *) arr[input];
}
