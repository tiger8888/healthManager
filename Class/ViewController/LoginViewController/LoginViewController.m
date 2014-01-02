//
//  LoginViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-11-29.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [self layoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background"]];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint p = [touch locationInView:self.view];
    NSLog(@"%f %f",p.x,p.y);
    [self.phoneNumber resignFirstResponder];
    [self.password resignFirstResponder];
}

- (IBAction)onClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1:
        {
            NSLog(@"登陆");
        }
            break;
        case 2:
        {
            NSLog(@"忘记密码");
        }
            break;
        default:
            break;
    }
    
    MainViewController *mainViewCtl = [MainViewController new];
    [self presentViewController:mainViewCtl animated:YES completion:NULL];
    
}
@end
