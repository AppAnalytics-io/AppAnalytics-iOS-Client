#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KeyboardWatcher : NSObject

+ (instancetype)instance;

@property (nonatomic, getter=isKeyboardShown, readonly) BOOL keyboardShown;
@property (nonatomic, readonly) CGRect keyboardFrame;

@end
