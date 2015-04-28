#import <Foundation/Foundation.h>

@interface AAEvent : NSObject <NSCoding>

@property (nonatomic, readonly, copy) NSArray* indices;
@property (nonatomic, readonly, copy) NSArray* timestamps;
@property (nonatomic, readonly, copy) NSString* descriptionText;
@property (nonatomic, readonly, copy) NSDictionary* parameters;

- (BOOL)isEqualToEvent:(AAEvent*)anotherEvent;

+ (instancetype)eventWithIndex:(NSUInteger)index
                     timestamp:(NSTimeInterval)timestamp
                   description:(NSString*)description
                    parameters:(NSDictionary*)parameters;

+ (instancetype)eventWithIndex:(NSArray*)indices
                    timestamps:(NSArray*)timestamps
                   description:(NSString*)description
                    parameters:(NSDictionary*)parameters;

- (void)addTimestamp:(NSTimeInterval)timestamp;

- (void)addIndex:(NSUInteger)index;

@end
