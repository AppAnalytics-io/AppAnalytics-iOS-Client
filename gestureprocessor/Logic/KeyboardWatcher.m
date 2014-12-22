#import "KeyboardWatcher.h"

@interface KeyboardWatcher ()
@property (nonatomic, readwrite) BOOL keyboardShown;
@property (nonatomic, readwrite) CGRect keyboardFrame;
@end

@implementation KeyboardWatcher

+ (instancetype)instance
{
    static KeyboardWatcher* _self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _self = [[KeyboardWatcher alloc] init];
    });
    return _self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addObservers];
    }
    return self;
}

- (void)dealloc
{
    [self removeObservers];
}

#pragma mark - Keyboard Observers

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    self.keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardShown = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardShown = NO;
}

@end
