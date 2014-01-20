//
//  LoginViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-11-29.
//
//

#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"

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
            
            if ([self checkLength] == NO)
            {
                ALERT(@"输入格式有误", @"您输入的手机号或密码长度不正确请检查后重试", @"返回");
            }
            else
            {
                [[HttpRequestManager sharedManager] requestLoginWithData:[self setUpParameters] completionHandle:^(id returnObject) {
                    NSString *str = [[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",str);
                    NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
                    NSDictionary *resultInfo = [returnDict categoryObjectForKey:@"resultInfo"];
                    if ([self checkReturnInfor:resultInfo]) {
                        [self goToMainViewController];
                    }
                    
                } failed:^{
                    ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
                } hitSuperView:self.view];
            }
            
        }
            break;
        case 2:
        {
            NSLog(@"忘记密码");
            [self pushToForgetViewController];
        }
            break;
        default:
            break;
    }
}

- (NSData *)setUpParameters
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:_phoneNumber.text forKey:@"m"];
    [parameter setObject:_password.text forKey:@"p"];
    
    NSData *tmpDate = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *base64Str = [tmpDate base64EncodedString];

    NSData *base64Data = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
    return base64Data;
}

- (BOOL)checkLength
{
    NSUInteger pnLength = _phoneNumber.text.length;
    NSUInteger pwLength = _password.text.length;
    if (pnLength != 11 || pwLength < 6 ) {
        
        return NO;
    }
    return YES;
}

- (BOOL)checkReturnInfor:(NSDictionary *)dict
{
    int r = [[dict categoryObjectForKey:@"retCode"] intValue];
    switch (r) {
        case 1:
        {
            NSDictionary *patient = [dict categoryObjectForKey:@"patient"];
            NSString *name = [patient categoryObjectForKey:@"name"];
            NSNumber *patientID = [patient categoryObjectForKey:@"patientId"];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSString *doctorID = [patient categoryObjectForKey:@"doctorId"];
            [userDef setObject:name forKey:@"name"];
            [userDef setObject:patientID forKey:PATIENTID_KEY];
            [userDef setObject:doctorID forKey:DOCTORID_KEY];
            [userDef synchronize];
            return YES;
        }
            break;
        case 2:
        {
            ALERT(@"", @"", @"");
        }
            break;
        case 3:
        {
            ALERT(@"", @"", @"");
        }
            break;
        default:
            break;
    }
    return NO;
}

- (void)goToMainViewController
{
    UINavigationController *mainNavCtl = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithCategory:0]];
    [self presentViewController:mainNavCtl animated:YES completion:NULL];
}

- (void)pushToForgetViewController
{
    ForgetPasswordViewController *forgetPasswordViewCtl = [[ForgetPasswordViewController alloc] initWithCategory:13];
    UINavigationController *mainNavCtl = [[UINavigationController alloc] initWithRootViewController:forgetPasswordViewCtl];
    [self presentViewController:mainNavCtl animated:YES completion:NULL];
}
@end
