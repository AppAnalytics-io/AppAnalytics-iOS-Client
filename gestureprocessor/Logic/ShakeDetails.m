#import "ShakeDetails.h"
#import "GestureProcessorHelpers.h"

@interface LogObject (ShakeDetails)

@property (nonatomic, strong, readwrite) UIGestureRecognizer* gestureRecognizer;

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;

@end

@implementation ShakeDetails

#pragma mark - LogInfo protocol

- (instancetype)initWithIndex:(NSUInteger)index
{
    self = [super init];
    if (self)
    {
        self.type = ActionType_Shake;
        self.timestamp = [NSDate new];
        self.position = CGPointZero;
        self.triggerViewControllerID = [GestureProcessorHelpers topViewControllerClassName];
        self.index = index;
    }
    return self;
}

@end
