//
//  ModifyPasswordViewController.m
//  HealthManager
//
//  Created by PanPeng on 14-1-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController
//@synthesize oldPassword, newPassword, confirmPassword, validationCode;

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
    [self.nePassword resignFirstResponder];
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
    if ( ![[Message sharedManager] checkPassword:self.oldPassword.text] ) {
//        [self.oldPassword becomeFirstResponder];
        return;
    }
    if ( ![[Message sharedManager] checkPassword:self.nePassword.text] ) {
        return;
    }
    if ( ![[Message sharedManager] checkPassword:self.confirmPassword.text] ) {
        return;
    }
    if ( ![[Message sharedManager] checkValidationCode:self.validationCode.text] ) {
        return;
    }
    
    
    NSString *resetPasswordUrl = [NSString stringWithFormat:@"resetPassword/%@.json", [[UserBusiness sharedManager] getCurrentPatientID]];

    [[HttpRequestManager sharedManager] requestSecretData:[self setUpParameters] interface:resetPasswordUrl completionHandle:^(id returnObject) {
        NSString *str = [[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *resultInfo = [returnDict categoryObjectForKey:@"resultInfo"];
        if ( [[Message sharedManager] checkReturnInfor:resultInfo] ) {
            ALERT(@"修改密码", @"密码修改成功，请记住您的新密码", @"确定");
        }
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
    } hitSuperView:self.view];
}

- (IBAction)resetOnClick:(id)sender {
    self.oldPassword.text = @"";
    self.nePassword.text = @"";
    self.confirmPassword.text = @"";
    self.validationCode.text = @"";
}

- (NSData *)setUpParameters
{
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:mobile forKey:@"m"];
    [parameter setObject:[[UserBusiness sharedManager] getCurrentPatientID] forKey:@"patientId"];
    [parameter setObject:self.oldPassword.text forKey:@"oldPassword"];
    [parameter setObject:self.validationCode.text forKey:@"verifyCode"];
    [parameter setObject:self.nePassword.text forKey:@"newPassword"];
    [parameter setObject:self.confirmPassword.text forKey:@"rePassword"];
    
    NSData *tmpDate = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *base64Str = [tmpDate base64EncodedString];
    
    NSData *base64Data = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
    return base64Data;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
