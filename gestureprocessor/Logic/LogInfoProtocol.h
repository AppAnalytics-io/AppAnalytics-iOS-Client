#pragma once
#import <UIKit/UIKit.h>

typedef NS_ENUM(u_int8_t, ActionType)
{
    ActionType_Unknown = 0,
    ActionType_SingleTap,
    ActionType_DoubleTap,
    ActionType_TripleTap,
    ActionType_LongTap,
    ActionType_Pinch,
    ActionType_Rotate,
    ActionType_Swipe,
    ActionType_Shake
};

extern NSString* NSStringWithActionType(ActionType input);

@protocol LogInfo <NSObject>

- (float)info;
- (NSString*)typeName;

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) ActionType type;
@property (nonatomic, strong, readonly) NSDate* timestamp;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, strong, readonly) NSString* triggerViewControllerID;
@property (nonatomic, strong, readonly) NSString* triggerViewID;

@end