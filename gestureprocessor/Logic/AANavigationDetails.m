#import "AANavigationDetails.h"

@interface LogObject (NavigationDetails)

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) ActionType type;
@property (nonatomic, strong, readwrite) NSDate* timestamp;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, copy, readwrite) NSString* triggerViewControllerID;
@property (nonatomic, copy, readwrite) NSString* triggerViewID;
@property (nonatomic, copy, readwrite) NSString* parameters;

@end

@implementation AANavigationDetails

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
    }
    return self;
}

@end
