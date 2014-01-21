//
//  ModifyPasswordViewController.m
//  HealthManager
//
//  Created by user on 14-1-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.oldPassword resignFirstResponder];
    [self.newPassword resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
    [self.validationCode resignFirstResponder];
}

- (IBAction)getValidationCode:(id)sender {
    NSLog(@"开始发送短信");
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    [parameter setObject:mobile forKey:@"mobileNo"];
    NSString *interfaceUrl = [NSString stringWithFormat:@"generateVerifyCode/%@.json", mobile];
    
    [[HttpRequestManager sharedManager] requestWithParameters:parameter interface:interfaceUrl completionHandle:^(id returnObject) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSString *result = [[dataDictionary objectForKey:@"resultInfo"] objectForKey:@"retCode"];
        NSLog(@"code=%@", result);
        
        //获取成功提示信息
        ALERT(@"获取验证码", @"验证码已成功发送到您登录手机号码中，请稍后查收。", @"确定");
        
        
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
    } hitSuperView:self.view method:kGet];
}

- (IBAction)submitOnClick:(id)sender {
    
}

- (IBAction)resetOnClick:(id)sender {
    self.oldPassword.text = @"";
    self.newPassword.text = @"";
    self.confirmPassword.text = @"";
    self.validationCode.text = @"";
}
@end
