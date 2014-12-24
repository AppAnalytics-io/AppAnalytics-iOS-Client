#import "LogInfo.h"

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

@interface LogObject ()

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;

@end

@implementation LogObject

- (float)info
{
    return 0;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.index) forKey:@"index"];
    [encoder encodeObject:@(self.type) forKey:@"type"];
    [encoder encodeObject:[NSValue valueWithCGPoint:self.position] forKey:@"position"];
    [encoder encodeObject:self.timestamp forKey:@"timestamp"];
    [encoder encodeObject:self.triggerViewControllerID forKey:@"triggerViewControllerID"];
    [encoder encodeObject:self.triggerViewID forKey:@"triggerViewID"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.index = [[decoder decodeObjectForKey:@"index"] unsignedIntegerValue];
        self.type = [[decoder decodeObjectForKey:@"type"] unsignedCharValue];
        self.position = [[decoder decodeObjectForKey:@"position"] CGPointValue];
        self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
        self.triggerViewControllerID = [decoder decodeObjectForKey:@"triggerViewControllerID"];
        self.triggerViewID = [decoder decodeObjectForKey:@"triggerViewID"];
    }
    return self;
}

@end

