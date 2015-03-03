#import "ViewController.h"
#import "TestViewController.h"
#import "AppAnalytics.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    self.view.backgroundColor = color;
    
    self.indexLabel.text = [NSString stringWithFormat:@"index: %d", (int)self.index];
    
    self.view.multipleTouchEnabled = YES;
    
//    [self test];
}

- (IBAction)pushUINavController:(UIButton *)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Title"
                                message:@"Message"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
//    if (!(self.index % 3) && self.index > 0)
//    {
//        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
//    
//    static int flag;
//    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    if (flag & 1)
//    {
//        ViewController *viewCon = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
//        viewCon.index = ++self.index;
//        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:viewCon];
//        [self presentViewController:navController animated:YES completion:nil];
//    }
//    else
//    {
//        NSMutableArray* vcs = [NSMutableArray array];
//        for (int vcIndex = 0; vcIndex < 4; vcIndex++)
//        {
//            ViewController* vc = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
//            vc.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:arc4random_uniform(UITabBarSystemItemMostViewed)
//                                                                       tag:vcIndex];
//            vc.index = self.index + vcIndex + 1;
//            [vcs addObject:vc];
//        }
//        
//        UITabBarController* tabBarController = [[UITabBarController alloc] init];
//        tabBarController.viewControllers = vcs.copy;
//        [self presentViewController:tabBarController animated:YES completion:nil];
//    }
//    flag++;
}

- (void)test
{
    int repeats = 1000;
    for (int i = 0; i < repeats; i++)
    {
        [self processIteration];
    }
}

- (void)processIteration
{
    [AppAnalytics logEvent:[NSString stringWithFormat:@"Event %lu", (unsigned long) [@(arc4random()) hash]]];
}


@end
