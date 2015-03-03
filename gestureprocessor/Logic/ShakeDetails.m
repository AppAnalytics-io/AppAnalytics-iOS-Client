#import "ShakeDetails.h"
#import "AppAnalyticsHelpers.h"

@interface LogObject (ShakeDetails)

@property (nonatomic, strong, readwrite) UIGestureRecognizer* gestureRecognizer;

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;
@property (nonatomic, readwrite) BOOL responsive;

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
        self.triggerViewControllerID = [AppAnalyticsHelpers topViewControllerClassName];
        self.index = index;
        self.responsive = YES;
    }
    return self;
}

@end
