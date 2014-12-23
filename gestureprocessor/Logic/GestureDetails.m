#import "GestureDetails.h"
#import "UISwipeGestureRecognizer+DirectionString.h"
#import "GestureTrackerHelpers.h"
#import "UIGestureRecognizer+Type.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface GestureDetails ()

@property (nonatomic, strong, readwrite) UIGestureRecognizer* gestureRecognizer;

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;

@end

@implementation GestureDetails

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer index:(NSUInteger)index
{
    self = [super init];
    if (self)
    {
        self.gestureRecognizer = gestureRecognizer;
        self.index = index;
        [self configure];
    }
    return self;
}

- (instancetype)initWithType:(ActionType)type
             triggerPosition:(CGPoint)position
               triggerViewID:(NSString *)viewID
                       index:(NSUInteger)index
{
    self = [super init];
    if (self)
    {
        self.type = type;
        self.timestamp = [NSDate new];
        self.triggerViewControllerID = [GestureTrackerHelpers topViewControllerClassName];
        self.position = position;
        self.triggerViewID = viewID;
        self.index = index;
    }
    return self;
}

- (void)configure
{
    if (self.gestureRecognizer.isSingleTap)
    {
        self.type = ActionType_SingleTap;
    }
    else if (self.gestureRecognizer.isDoubleTap)
    {
        self.type = ActionType_DoubleTap;
    }
    else if (self.gestureRecognizer.isTripleTap)
    {
        self.type = ActionType_TripleTap;
    }
    else if (self.gestureRecognizer.isLongTap)
    {
        self.type = ActionType_LongTap;
    }
    else if (self.gestureRecognizer.isPinch)
    {
        self.type = ActionType_Pinch;
    }
    else if (self.gestureRecognizer.isRotate)
    {
        self.type = ActionType_Rotate;
    }
    else if (self.gestureRecognizer.isSwipe)
    {
        self.type = ActionType_Swipe;
    }
    else
    {
        self.type = ActionType_Unknown;
    }
    
    self.timestamp = [NSDate new];
    UIViewController* topVC = [GestureTrackerHelpers topViewController];
    self.position = [self.gestureRecognizer locationInView:topVC.view];
    self.triggerViewID = [GestureTrackerHelpers subviewClassNameAtPosition:self.position ofView:topVC.view];
    self.triggerViewControllerID = [GestureTrackerHelpers topViewControllerClassName];
}

#pragma mark - LogInfo protocol

- (NSString*)typeName
{
    return [NSString stringWithFormat:@"%@With%luFinger", NSStringWithActionType(self.type),
            (unsigned long)self.numberOfTouches];
}

- (float)info
{
//    NSString* info = nil;
    float info = 0;
    if (self.gestureRecognizer.isPinch)
    {
        UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer*) self.gestureRecognizer;
        info = pinch.scale;
//        info = [NSString stringWithFormat:@"%.3f", pinch.scale];
    }
    else if (self.gestureRecognizer.isRotate)
    {
        UIRotationGestureRecognizer* rotate = (UIRotationGestureRecognizer*) self.gestureRecognizer;
        info = RADIANS_TO_DEGREES(rotate.rotation);
//        info = [NSString stringWithFormat:@"%.3f", RADIANS_TO_DEGREES(rotate.rotation)];
    }
    else if (self.gestureRecognizer.isSwipe)
    {
        UISwipeGestureRecognizer* swipe = (UISwipeGestureRecognizer*) self.gestureRecognizer;
        info = swipe.direction;
//        info = [NSString stringWithFormat:@"%@", swipe.directionText];
    }
    return info;
}

- (NSUInteger)numberOfTouches
{
    if (self.gestureRecognizer.isPinch || self.gestureRecognizer.isRotate)
    {
        return 2;
    }
    else
    {
        return self.gestureRecognizer.numberOfTouches;
    }
}

@end
