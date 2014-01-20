//
//  ForgetPasswordViewController.m
//  HealthManager
//
//  Created by user on 14-1-20.
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
    [self createBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createBackButton
{
    _backButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButtonItem.frame = CGRectMake(10, 0, 44, 44);
    [_backButtonItem setImage:[UIImage imageNamed:@"bbi_left"] forState:UIControlStateNormal];
    [_backButtonItem addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:_backButtonItem];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mobile resignFirstResponder];
}

- (void)backButtonClick
{
    NSLog(@"back");
    LoginViewController *loginViewCtl = [LoginViewController new];
    [self presentModalViewController:loginViewCtl animated:YES];
}
- (IBAction)next:(id)sender {
    //验证手机号码格式
    ALERTOPRATE(@"确认手机号", @"我们将发送验证码短信到这个号码：22222222", 1);
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
                ForgetPasswordSetPWDViewController *setPWDViewCtl = [[ForgetPasswordSetPWDViewController alloc] initWithCategory:14];
//                [self presentModalViewController:setPWDViewCtl animated:YES];
                [self.navigationController pushViewController:setPWDViewCtl animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

@end
