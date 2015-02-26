#import <Foundation/Foundation.h>

@interface NSUserDefaults (SaveCustomObject)

- (void)saveCustomObject:(id)object key:(NSString *)key;
- (id)loadCustomObjectWithKey:(NSString *)key;

@end
