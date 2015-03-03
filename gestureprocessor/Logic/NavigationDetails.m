#import "NavigationDetails.h"

@interface LogObject (NavigationDetails)

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, strong, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, strong, readwrite) NSString* triggerViewID;
@property (nonatomic, readwrite) BOOL responsive;

@end

@implementation NavigationDetails

#pragma mark - LogInfo protocol

- (instancetype)initWithIndex:(NSUInteger)index triggerViewControllerID:(NSString *)triggerVcID
{
    self = [super init];
    if (self)
    {
        self.type = ActionType_Navigation;
        self.timestamp = [NSDate new];
        self.position = CGPointZero;
        self.triggerViewControllerID = triggerVcID;
        self.index = index;
        self.responsive = YES;
    }
    return self;
}

@end
