#import "GestureDetails.h"
#import "UISwipeGestureRecognizer+DirectionString.h"
#import "AppAnalyticsHelpers.h"
#import "UIGestureRecognizer+Type.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface LogObject (GestureDetails)

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;

@end

@interface GestureDetails ()

@property (nonatomic, strong, readwrite) UIGestureRecognizer* gestureRecognizer;

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
        self.triggerViewControllerID = [AppAnalyticsHelpers topViewControllerClassName];
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
    UIViewController* topVC = [AppAnalyticsHelpers topViewController];
    self.position = [self.gestureRecognizer locationInView:topVC.view];
    self.triggerViewID = [AppAnalyticsHelpers subviewClassNameAtPosition:self.position ofView:topVC.view];
    self.triggerViewControllerID = [AppAnalyticsHelpers topViewControllerClassName];
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
    return info;
}

@end
