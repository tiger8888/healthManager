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
//    UINavigationController *mainNavCtl;
    switch (button.tag) {
        case 1:
        {
            NSLog(@"登陆");
            int pnLength = _phoneNumber.text.length;
            int pwLength = _password.text.length;
            if (pnLength != 11 || pwLength < 6 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入格式有误" message:@"您输入的手机号或密码长度不正确请检查后重试" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
                [alert show];
                return;
            }
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
            [parameter setObject:_phoneNumber.text forKey:@"m"];
            [parameter setObject:_password.text forKey:@"p"];
            
            NSData *tmpDate = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *base64Str = [tmpDate base64EncodedString];
            NSLog(@"%@",base64Str);
            NSData *base64Data = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
            
            [[HttpRequestManager sharedManager] requestLoginWithData:base64Data];
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
    
//    mainNavCtl = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithCategory:0]];
//    [self presentViewController:mainNavCtl animated:YES completion:NULL];
    
}
@end
