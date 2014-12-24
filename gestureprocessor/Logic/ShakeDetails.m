#import "ShakeDetails.h"
#import "GestureTrackerHelpers.h"

@interface ShakeDetails ()

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
        self.triggerViewControllerID = [GestureTrackerHelpers topViewControllerClassName];
        self.index = index;
    }
    return self;
}

- (float)info
{
    return 0;
}

@end
