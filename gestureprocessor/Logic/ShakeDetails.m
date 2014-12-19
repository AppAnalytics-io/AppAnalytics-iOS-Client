#import "ShakeDetails.h"

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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.type = ActionType_Shake;
        self.timestamp = [NSDate new];
        self.position = CGPointZero;
    }
    return self;
}

- (NSString*)typeTextName
{
    return @"Shake";
}

- (NSString*)info
{
    return [self typeTextName];
}

@end
