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
    self.type = [self.gestureRecognizer actionType];
    
    self.timestamp = [NSDate new];
    UIViewController* topVC = [GestureTrackerHelpers topViewController];
    self.position = [self.gestureRecognizer locationInView:topVC.view];
    self.triggerViewID = [GestureTrackerHelpers subviewClassNameAtPosition:self.position ofView:topVC.view];
    self.triggerViewControllerID = [GestureTrackerHelpers topViewControllerClassName];
}

#pragma mark - LogInfo protocol

- (float)info
{
    float info = 0;
    if (self.gestureRecognizer.isPinch)
    {
        UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer*) self.gestureRecognizer;
        info = pinch.scale;
    }
    else if (self.gestureRecognizer.isRotate)
    {
        UIRotationGestureRecognizer* rotate = (UIRotationGestureRecognizer*) self.gestureRecognizer;
        info = RADIANS_TO_DEGREES(rotate.rotation);
    }
#if 0
    else if (self.gestureRecognizer.isSwipe)
    {
        UISwipeGestureRecognizer* swipe = (UISwipeGestureRecognizer*) self.gestureRecognizer;
        info = swipe.direction;
    }
#endif
    return info;
}

@end
