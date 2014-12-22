#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)swizzleOriginalMethod:(SEL)originalSelector with:(SEL)swizzledSelector;

@end
