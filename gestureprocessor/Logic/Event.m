#import "Event.h"

@interface Event ()

@property (nonatomic, readwrite, copy) NSArray* indices;
@property (nonatomic, readwrite, copy) NSArray* timestamps;
@property (nonatomic, readwrite, copy) NSString* descriptionText;
@property (nonatomic, readwrite, copy) NSDictionary* parameters;

@end

@implementation Event

+ (instancetype)eventWithIndex:(NSUInteger)index
                     timestamp:(NSTimeInterval)timestamp
                   description:(NSString*)description
                    parameters:(NSDictionary*)parameters
{
    Event* event = [[Event alloc] init];
    if (event)
    {
        event.indices = @[@(index)];
        event.timestamps = @[@(timestamp)];
        event.descriptionText = description;
        event.parameters = parameters;
    }
    return event;
}

+ (instancetype)eventWithIndex:(NSArray*)indices
                    timestamps:(NSArray*)timestamps
                   description:(NSString*)description
                    parameters:(NSDictionary*)parameters
{
    Event* event = [[Event alloc] init];
    if (event)
    {
        event.indices = indices;
        event.timestamps = timestamps;
        event.descriptionText = description;
        event.parameters = parameters;
    }
    return event;
}

- (void)addTimestamp:(NSTimeInterval)timestamp
{
    NSMutableArray* tempTimestamps = self.timestamps.mutableCopy;
    if (!tempTimestamps)
    {
        tempTimestamps = [NSMutableArray array];
    }
    [tempTimestamps addObject:@(timestamp)];
    self.timestamps = tempTimestamps.copy;
}

- (void)addIndex:(NSUInteger)index
{
    NSMutableArray* tempIndices = self.indices.mutableCopy;
    if (!tempIndices)
    {
        tempIndices = [NSMutableArray array];
    }
    [tempIndices addObject:@(index)];
    self.indices = tempIndices.copy;
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;

    if (!other || ![other isKindOfClass:[self class]])
        return NO;

    return [self isEqualToEvent:other];
}

- (BOOL)isEqualToEvent:(Event *)anotherEvent
{
    if (self == anotherEvent)
        return YES;
    
    if ((self.descriptionText || anotherEvent.descriptionText) &&
        ![self.descriptionText isEqualToString:anotherEvent.descriptionText])
        return NO;
    
    if ((self.parameters || anotherEvent.parameters) &&
        ![self.parameters isEqualToDictionary:anotherEvent.parameters])
        return NO;

    return YES;
}

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))
- (NSUInteger)hash
{
    return NSUINTROTATE([self.descriptionText hash], NSUINT_BIT / 2) ^ [self.parameters hash];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.indices forKey:@"indices"];
    [coder encodeObject:self.timestamps forKey:@"timestamps"];
    [coder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [coder encodeObject:self.parameters forKey:@"parameters"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    self.indices = [coder decodeObjectForKey:@"indices"];
    self.timestamps = [coder decodeObjectForKey:@"timestamps"];
    self.descriptionText = [coder decodeObjectForKey:@"descriptionText"];
    self.parameters = [coder decodeObjectForKey:@"parameters"];
    return self;
}

@end
