#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    self.view.backgroundColor = color;
    
    self.indexLabel.text = [NSString stringWithFormat:@"index: %lu", self.index];
}

- (IBAction)pushUINavController:(UIButton *)sender
{
    static int flag;
    
    if (flag & 1)
    {
        ViewController *viewCon =
        [[UIStoryboard storyboardWithName:@"Main"
                                   bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    
        viewCon.index = ++self.index;
    
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:viewCon];
    
        [self presentViewController:navController animated:YES completion:nil];
    }
    else
    {
        ViewController *viewCon1 =
        [[UIStoryboard storyboardWithName:@"Main"
                                   bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        viewCon1.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
        viewCon1.index = ++self.index;
        
        ViewController *viewCon2 =
        [[UIStoryboard storyboardWithName:@"Main"
                                   bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        viewCon2.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        viewCon2.index = ++self.index;
        
        ViewController *viewCon3 =
        [[UIStoryboard storyboardWithName:@"Main"
                                   bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        viewCon3.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];
        viewCon3.index = ++self.index;
        
        ViewController *viewCon4 =
        [[UIStoryboard storyboardWithName:@"Main"
                                   bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        viewCon4.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:3];
        viewCon4.index = ++self.index;
        
        UITabBarController* tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
        tabBarController.viewControllers = [[NSArray alloc] initWithObjects:viewCon1, viewCon2, viewCon3, viewCon4, nil];
        
        [self presentViewController:tabBarController animated:YES completion:nil];
    }
    flag++;
}

@end
