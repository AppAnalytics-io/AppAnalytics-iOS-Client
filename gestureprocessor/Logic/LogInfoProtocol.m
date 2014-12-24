#import "LogInfoProtocol.h"

static NSDictionary* typeNames;
NSString* NSStringWithActionType(ActionType action)
{
    typeNames = @{
                  @(ActionType_Unknown)                 : @"Unknown=0",
                  @(ActionType_SingleTapWith1Finger)    : @"SingleTapWith1Finger=1",
                  @(ActionType_DoubleTapWith1Finger)    : @"DoubleTapWith1Finger=2",
                  @(ActionType_TripleTapWith1Finger)    : @"TripleTapWith1Finger=3",
                  @(ActionType_SingleTapWith2Finger)    : @"SingleTapWith2Finger=4",
                  @(ActionType_DoubleTapWith2Finger)    : @"DoubleTapWith2Finger=5",
                  @(ActionType_TripleTapWith2Finger)    : @"TripleTapWith2Finger=6",
                  @(ActionType_SingleTapWith3Finger)    : @"SingleTapWith3Finger=7",
                  @(ActionType_DoubleTapWith3Finger)    : @"DoubleTapWith3Finger=8",
                  @(ActionType_TripleTapWith3Finger)    : @"TripleTapWith3Finger=9",
                  @(ActionType_SingleTapWith4Finger)    : @"SingleTapWith4Finger=10",
                  @(ActionType_DoubleTapWith4Finger)    : @"DoubleTapWith4Finger=11",
                  @(ActionType_TripleTapWith4Finger)    : @"TripleTapWith4Finger=12",
                  @(ActionType_LongPressWith1Finger)    : @"HoldWith1Finger=13",
                  @(ActionType_LongPressWith2Finger)    : @"HoldWith2Finger=14",
                  @(ActionType_LongPressWith3Finger)    : @"HoldWith3Finger=15",
                  @(ActionType_LongPressWith4Finger)    : @"HoldWith4Finger=16",
                  @(ActionType_PinchWith2Finger)        : @"PinchWith2Finger=17",
                  @(ActionType_RotateWith2Finger)       : @"RotateWith2Finger=19",
                  @(ActionType_SwipeRightWith1Finger)   : @"SwipeRightWith1Finger=20",
                  @(ActionType_SwipeLeftWith1Finger)    : @"SwipeLeftWith1Finger=21",
                  @(ActionType_SwipeDownWith1Finger)    : @"SwipeDownWith1Finger=22",
                  @(ActionType_SwipeUpWith1Finger)      : @"SwipeUpWith1Finger=23",
                  @(ActionType_SwipeRightWith2Finger)   : @"SwipeRightWith2Finger=28",
                  @(ActionType_SwipeLeftWith2Finger)    : @"SwipeLeftWith2Finger=29",
                  @(ActionType_SwipeDownWith2Finger)    : @"SwipeDownWith2Finger=30",
                  @(ActionType_SwipeUpWith2Finger)      : @"SwipeUpWith2Finger=31",
                  @(ActionType_SwipeRightWith3Finger)   : @"SwipeRightWith3Finger=36",
                  @(ActionType_SwipeLeftWith3Finger)    : @"SwipeLeftWith3Finger=37",
                  @(ActionType_SwipeDownWith3Finger)    : @"SwipeDownWith3Finger=38",
                  @(ActionType_SwipeUpWith3Finger)      : @"SwipeUpWith3Finger=39",
                  @(ActionType_SwipeRightWith4Finger)   : @"SwipeRightWith4Finger=44",
                  @(ActionType_SwipeLeftWith4Finger)    : @"SwipeLeftWith4Finger=45",
                  @(ActionType_SwipeDownWith4Finger)    : @"SwipeDownWith4Finger=46",
                  @(ActionType_SwipeUpWith4Finger)      : @"SwipeUpWith4Finger=47",
                  @(ActionType_Shake)                   : @"Shake=52",
                  @(ActionType_Navigation)              : @"Navigation=53"
             };
    return (NSString *) typeNames[@(action)];
}

#if 0
static u_int8_t allTypes[] = {
    ActionType_Unknown,
    ActionType_SingleTapWith1Finger,
    ActionType_DoubleTapWith1Finger,
    ActionType_TripleTapWith1Finger,
    ActionType_SingleTapWith2Finger,
    ActionType_DoubleTapWith2Finger,
    ActionType_TripleTapWith2Finger,
    ActionType_SingleTapWith3Finger,
    ActionType_DoubleTapWith3Finger,
    ActionType_TripleTapWith3Finger,
    ActionType_SingleTapWith4Finger,
    ActionType_DoubleTapWith4Finger,
    ActionType_TripleTapWith4Finger,
    ActionType_LongPressWith1Finger,
    ActionType_LongPressWith2Finger,
    ActionType_LongPressWith3Finger,
    ActionType_LongPressWith4Finger,
    ActionType_PinchWith2Finger,
    ActionType_RotateWith2Finger,
    ActionType_SwipeRightWith1Finger,
    ActionType_SwipeLeftWith1Finger,
    ActionType_SwipeDownWith1Finger,
    ActionType_SwipeUpWith1Finger,
    ActionType_SwipeRightWith2Finger,
    ActionType_SwipeLeftWith2Finger,
    ActionType_SwipeDownWith2Finger,
    ActionType_SwipeUpWith2Finger,
    ActionType_SwipeRightWith3Finger,
    ActionType_SwipeLeftWith3Finger,
    ActionType_SwipeDownWith3Finger,
    ActionType_SwipeUpWith3Finger,
    ActionType_SwipeRightWith4Finger,
    ActionType_SwipeLeftWith4Finger,
    ActionType_SwipeDownWith4Finger,
    ActionType_SwipeUpWith4Finger,
    ActionType_Shake,
    ActionType_Navigation
};

void debugPrintAllTypes()
{  
    for (int i = 0; i < 37; i++)
    {
        NSLog(@"%d", allTypes[i]);
    }
}
#endif