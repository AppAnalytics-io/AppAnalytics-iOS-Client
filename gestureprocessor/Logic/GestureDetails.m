#import "GestureDetails.h"
#import "UISwipeGestureRecognizer+DirectionString.h"
#import "GestureTrackerHelpers.h"

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
    if (self.isSingleTap)
    {
        self.type = ActionType_SingleTap;
    }
    else if (self.isDoubleTap)
    {
        self.type = ActionType_DoubleTap;
    }
    else if (self.isTripleTap)
    {
        self.type = ActionType_TripleTap;
    }
    else if (self.isLongTap)
    {
        self.type = ActionType_LongTap;
    }
    else if (self.isPinch)
    {
        self.type = ActionType_Pinch;
    }
    else if (self.isRotate)
    {
        self.type = ActionType_Rotate;
    }
    else if (self.isSwipe)
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

- (NSString*)info
{
    NSString* info = nil;
    if (self.isPinch)
    {
        UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer*) self.gestureRecognizer;
        info = [NSString stringWithFormat:@"%.3f", pinch.scale];
    }
    else if (self.isRotate)
    {
        UIRotationGestureRecognizer* rotate = (UIRotationGestureRecognizer*) self.gestureRecognizer;
        info = [NSString stringWithFormat:@"%.3f", RADIANS_TO_DEGREES(rotate.rotation)];
    }
    else if (self.isSwipe)
    {
        UISwipeGestureRecognizer* swipe = (UISwipeGestureRecognizer*) self.gestureRecognizer;
        info = [NSString stringWithFormat:@"%@", swipe.directionText];
    }
    return info;
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
        UITapGestureRecognizer* tap = (UITapGestureRecognizer*) self.gestureRecognizer;
        return tap.numberOfTapsRequired == numberOfTaps;
    }
    return NO;
}

- (BOOL)checkGestureClass:(Class)class
{
    return [self.gestureRecognizer isKindOfClass:class];
}

@end
