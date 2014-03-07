//
//  ModifyPasswordViewController.m
//  HealthManager
//
//  Created by PanPeng on 14-1-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()
{
    CGRect _btnSubmitOriginalFrame;
}
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
    
    if (IS_IOS7) {
        //不需要根据键盘高度调整布局
    }else {
        _btnSubmitOriginalFrame = self.btnSubmit.frame;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    if (IS_IOS7) {
        
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
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

#pragma mark - keyboard
-(void)willShowKeyboard:(NSNotification *)notification{
    //    NSLog(@"will show keyboard");
    if (!self.oldPassword.isFirstResponder) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        int keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        self.btnSubmit.frame = CGRectOffset(self.btnSubmit.frame, 0, keyboardHeight-_btnSubmitOriginalFrame.origin.y);
        self.btnReset.frame = CGRectOffset(self.btnReset.frame, 0, keyboardHeight-_btnSubmitOriginalFrame.origin.y);
        [self resizeLayout:YES];
        
        [UIView commitAnimations];
    }
}
-(void)willHideKeyboard{
    //    NSLog(@"will hide keyboard");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    self.btnSubmit.frame = CGRectOffset(self.btnSubmit.frame, 0, _btnSubmitOriginalFrame.origin.y-self.btnSubmit.frame.origin.y);
    self.btnReset.frame = CGRectOffset(self.btnReset.frame, 0, _btnSubmitOriginalFrame.origin.y-self.btnReset.frame.origin.y);
    [self resizeLayout:NO];
    
    [UIView commitAnimations];
}

- (void)resizeLayout:(BOOL)up {
#define DREAM_FABS(ARG)  up?-fabs(ARG):fabs(ARG)
    
    
    self.btnGetValidationCode.frame = CGRectOffset(self.btnGetValidationCode.frame, 0, DREAM_FABS(self.btnSubmit.frame.origin.y-62-self.btnGetValidationCode.frame.origin.y));
    self.validationCode.frame = CGRectOffset(self.validationCode.frame, 0, DREAM_FABS(self.btnSubmit.frame.origin.y-62-self.validationCode.frame.origin.y));
    

    self.confirmPassword.frame = CGRectOffset(self.confirmPassword.frame, 0, DREAM_FABS(self.validationCode.frame.origin.y-44-self.confirmPassword.frame.origin.y));
    self.nePassword.frame = CGRectOffset(self.nePassword.frame, 0, DREAM_FABS(self.confirmPassword.frame.origin.y-44-self.nePassword.frame.origin.y));
    self.oldPassword.frame = CGRectOffset(self.oldPassword.frame, 0, DREAM_FABS(self.nePassword.frame.origin.y-44-self.oldPassword.frame.origin.y));
    
    self.validatonCodeLabel.frame = CGRectOffset(self.validatonCodeLabel.frame, 0, self.validationCode.frame.origin.y-self.validatonCodeLabel.frame.origin.y+8);
    self.confirmPasswordLabel.frame = CGRectOffset(self.confirmPasswordLabel.frame, 0, self.confirmPassword.frame.origin.y-self.confirmPasswordLabel.frame.origin.y+8);
    self.nePasswordLabel.frame = CGRectOffset(self.nePasswordLabel.frame, 0, self.nePassword
                                              .frame.origin.y-self.nePasswordLabel.frame.origin.y+8);

    self.oldPasswordLabel.frame = CGRectOffset(self.oldPasswordLabel.frame, 0, self.oldPassword.frame.origin.y-self.oldPasswordLabel.frame.origin.y+8);
}

@end
