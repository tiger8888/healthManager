//
//  MainViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-11-29.
//
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)buttonClick:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _nameLabel.text = [_nameLabel.text stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 2) {
        NSNumber *myDoctorID = [[NSUserDefaults standardUserDefaults] objectForKey:DOCTORID_KEY];
        if (!myDoctorID || [myDoctorID intValue] == 0)
        {
            [self goToFunctionPart:2];
        }
        else
        {
            [self goToFunctionPart:9];
        }
        return;
    }
    [self goToFunctionPart:button.tag];
}

- (void)goToFunctionPart:(NSUInteger)category
{
    NSString *classStr = [[[(AppDelegate *)([UIApplication sharedApplication].delegate) propertyList] objectAtIndex:category] objectForKey:@"class"];
    Class class = NSClassFromString(classStr);
    UIViewController * viewController = [[class alloc] initWithCategory:category];
    
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
