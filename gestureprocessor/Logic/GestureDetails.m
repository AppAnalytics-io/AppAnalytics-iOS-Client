#import "GestureDetails.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface GestureDetails ()

@property (nonatomic, strong, readwrite) NSString* typeName;
@property (nonatomic, strong, readwrite) UIGestureRecognizer* gestureRecognizer;

@end

@implementation GestureDetails

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
{
    self = [super init];
    if (self)
    {
        self.gestureRecognizer = gestureRecognizer;
        [self configure];
    }
    return self;
}

- (void)configure
{
    
}

- (NSString*)info
{
    NSString* info = [self gestureTypeName];
    if (self.isPinch)
    {
        UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer*) self.gestureRecognizer;
        info = [NSString stringWithFormat:@"%@ %.3f", info, pinch.scale];
    }
    else if (self.isRotate)
    {
        UIRotationGestureRecognizer* rotate = (UIRotationGestureRecognizer*) self.gestureRecognizer;
        info = [NSString stringWithFormat:@"%@ %.3f", info, RADIANS_TO_DEGREES(rotate.rotation)];
    }
    return info;
}

- (NSString*)gestureTypeName
{
    if (self.isSingleTap)
    {
        return @"Single Tap";
    }
    else if (self.isDoubleTap)
    {
        return @"Double Tap";
    }
    else if (self.isTripleTap)
    {
        return @"Triple Tap";
    }
    else if (self.isLongTap)
    {
        return @"Long Tap";
    }
    else if (self.isPinch)
    {
        return @"Pinch";
    }
    else if (self.isRotate)
    {
        return @"Rotate";
    }
    else if (self.isSwipe)
    {
        return @"Swipe";
    }
    else
    {
        return @"Unknown";
    }
    
    return nil;
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
