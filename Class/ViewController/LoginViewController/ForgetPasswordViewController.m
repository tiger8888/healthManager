//
//  ForgetPasswordViewController.m
//  HealthManager
//
//  Created by PanPeng on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPasswordSetPWDViewController.h"

@interface ForgetPasswordViewController ()
{
    UIButton *_backButtonItem;
}
@end

@implementation ForgetPasswordViewController
@synthesize mobile;

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
//    [self createBackButton];
    
    _lsMobile = [[LSTextField alloc] initWithFrame:CGRectMake(80, 129, 193, 36) andBackgroundImage:@"blood_texfield" andEditingBackgroundImage:@"blood_texfield_selected"];
    _lsMobile.retract = 4;
    _lsMobile.textField.placeholder = @"请输入您的手机号码";
    _lsMobile.textField.keyboardType = UIKeyboardTypeNumberPad;
    _lsMobile.textField.textAlignment = NSTextAlignmentCenter;
//    _lsMobile.layer.zPosition = -1;
    [self.view addSubview:_lsMobile];
    
    self.mobile.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_lsMobile.textField resignFirstResponder];
    
    [self.mobile resignFirstResponder];
}

//- (void)backButtonClick
//{
//    NSLog(@"back");
////    LoginViewController *loginViewCtl = [LoginViewController new];
////    [self presentModalViewController:loginViewCtl animated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}
- (IBAction)next:(id)sender {
    if ( ![[Message sharedManager] checkMobile:_lsMobile.textField.text] ) {
        return;
    }
    NSString *message = [NSString stringWithFormat:@"我们将发送验证码短信到这个号码：%@", _lsMobile.textField.text];
    ALERTOPRATE(@"确认手机号", message, 1);
}

#pragma mark - AlertDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
        {
            if (buttonIndex == 0) {
                return;
            }
            else if (buttonIndex == 1)
            {
                NSLog(@"开始发送短信");
                
                NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
                NSString *mobileCode = _lsMobile.textField.text;
                [parameter setObject:mobileCode forKey:@"mobileNo"];
                NSString *interfaceUrl = [NSString stringWithFormat:@"generateVerifyCode/%@.json", mobileCode];
                
                [[HttpRequestManager sharedManager] requestWithParameters:parameter interface:interfaceUrl completionHandle:^(id returnObject) {
                    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
                    NSString *result = [[dataDictionary objectForKey:@"resultInfo"] objectForKey:@"retCode"];
                    NSLog(@"code=%@", result);
                    ForgetPasswordSetPWDViewController *setPWDViewCtl = [[ForgetPasswordSetPWDViewController alloc] initWithCategory:14];
                    setPWDViewCtl.mobileCode = mobileCode;
                    [self.navigationController pushViewController:setPWDViewCtl animated:YES];
                    
                } failed:^{
                    ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
                } hitSuperView:self.view method:kGet];
            }
        }
            break;
        default:
            break;
    }
}

@end
