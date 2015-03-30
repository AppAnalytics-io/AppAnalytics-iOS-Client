#import <UIKit/UIKit.h>

typedef NS_ENUM(u_int8_t, ActionType)
{
    ActionType_Unknown                  = 0,
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
    ActionType_PinchWith2Finger         = 17,
    ActionType_RotateWith2Finger        = 19,
    ActionType_SwipeRightWith1Finger,
    ActionType_SwipeLeftWith1Finger,
    ActionType_SwipeDownWith1Finger,
    ActionType_SwipeUpWith1Finger,
    ActionType_SwipeRightWith2Finger    = 28,
    ActionType_SwipeLeftWith2Finger,
    ActionType_SwipeDownWith2Finger,
    ActionType_SwipeUpWith2Finger,
    ActionType_SwipeRightWith3Finger    = 36,
    ActionType_SwipeLeftWith3Finger,
    ActionType_SwipeDownWith3Finger,
    ActionType_SwipeUpWith3Finger,
    ActionType_SwipeRightWith4Finger    = 44,
    ActionType_SwipeLeftWith4Finger,
    ActionType_SwipeDownWith4Finger,
    ActionType_SwipeUpWith4Finger,
    ActionType_Shake                    = 52,
    ActionType_Navigation
};

// used to obtain action name from it's index in debug purposes
#ifdef DEBUG
extern NSString* NSStringWithActionType(ActionType input);
#endif

@protocol LogInfo <NSObject>

- (float)info;

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) ActionType type;
@property (nonatomic, strong, readonly) NSDate* timestamp;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, copy, readonly) NSString* triggerViewControllerID;
@property (nonatomic, copy, readonly) NSString* triggerViewID;
@property (nonatomic, copy, readonly) NSString* parameters;

@end

@interface LogObject : NSObject <LogInfo>

@end