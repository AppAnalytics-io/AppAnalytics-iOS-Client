#import "GestureDetails.h"

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
