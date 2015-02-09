#import "UIViewController+Tracking.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
#import "Logger.h"
#import <Foundation/Foundation.h>

@implementation UIViewController (Tracking)

static NSMutableSet* gHashes;
static NSUInteger const kMaxHashPool = 16;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self swizzleOriginalMethod:@selector(viewDidLoad)
                               with:@selector(viewDidLoadSwizzled)];
        
        [self swizzleOriginalMethod:@selector(viewWillAppear:)
                               with:@selector(viewWillAppearSwizzled:)];
        
        gHashes = [NSMutableSet set];
    });
}

- (void)viewDidLoadSwizzled
{
    [self viewDidLoadSwizzled];
    if (addObjectHash([self hash]))
    {
        [[Logger instance] navigationRecognizedWithViewControllerID:NSStringFromClass(self.class)];
    }
}

- (void)viewWillAppearSwizzled:(BOOL)animated
{
    [self viewWillAppearSwizzled:animated];
    if (addObjectHash([self hash]))
    {
        [[Logger instance] navigationRecognizedWithViewControllerID:NSStringFromClass(self.class)];
    }
}

static inline BOOL addObjectHash(NSUInteger hash)
{
    if (gHashes.count > kMaxHashPool)
    {
        [gHashes removeAllObjects];
    }
    
    id hashObject = @(hash);
    
    if ([gHashes containsObject:hashObject])
    {
        return NO;
    }
    else
    {
        [gHashes addObject:hashObject];
        return YES;
    }
}

@end
