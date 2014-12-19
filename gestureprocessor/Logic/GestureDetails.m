#import "GestureDetails.h"

@interface GestureDetails ()

@property (nonatomic, strong, readwrite) NSString* typeName;
@property (nonatomic, copy, readwrite) UIGestureRecognizer* gestureRecognizer;

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

- (NSString*)gestureTypeName
{
    if (self.isTap)
    {
        return @"Tap";
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
    
    return nil;
}

- (BOOL)isTap
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
