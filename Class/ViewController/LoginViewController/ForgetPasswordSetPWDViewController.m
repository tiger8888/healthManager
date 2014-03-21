//
//  ForgetPasswordSetPWDViewController.m
//  HealthManager
//
//  Created by PanPeng on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ForgetPasswordSetPWDViewController.h"

@interface ForgetPasswordSetPWDViewController ()
{
    CGRect _btnSubmitOriginalFrame;
}
@end

@implementation ForgetPasswordSetPWDViewController
@synthesize mobileCode, mobileLabel;

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
    self.mobileLabel.text = self.mobileCode;
    
    [self customInit];
    
    if (IS_IOS7) {
        //不需要根据键盘高度调整布局
    }else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard) name:UIKeyboardWillHideNotification object:nil];
    }
    
    _btnSubmitOriginalFrame = self.btnSubmit.frame;
}
- (void)customInit {
    int textFieldX = 108;
    int textFieldY = 140;
    int textFieldHeight = 36;
    int textFieldWidth = 192;
    _lsValidationCode = [[LSTextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, textFieldHeight) andBackgroundImage:@"blood_texfield" andEditingBackgroundImage:@"blood_texfield_selected"];
    _lsValidationCode.retract = 4;
    _lsValidationCode.textField.placeholder = @"请输入验证码";
    _lsValidationCode.textField.keyboardType = UIKeyboardTypeDefault;
    _lsValidationCode.textField.textAlignment = NSTextAlignmentCenter;
    _lsValidationCode.layer.zPosition = -1;
    [self.view addSubview:_lsValidationCode];
    
    textFieldY += 52;
    _lsNePassword = [[LSTextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, textFieldHeight) andBackgroundImage:@"blood_texfield" andEditingBackgroundImage:@"blood_texfield_selected"];
    _lsNePassword.retract = 4;
    _lsNePassword.textField.placeholder = @"请输入新密码";
    _lsNePassword.textField.keyboardType = UIKeyboardTypeDefault;
    _lsNePassword.textField.textAlignment = NSTextAlignmentCenter;
    _lsNePassword.textField.secureTextEntry = YES;
    _lsNePassword.layer.zPosition = -1;
    [self.view addSubview:_lsNePassword];
    
    textFieldY += 52;
    _lsConfirmPassword = [[LSTextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, textFieldHeight) andBackgroundImage:@"blood_texfield" andEditingBackgroundImage:@"blood_texfield_selected"];
    _lsConfirmPassword.retract = 4;
    _lsConfirmPassword.textField.placeholder = @"请输入确认新密码";
    _lsConfirmPassword.textField.keyboardType = UIKeyboardTypeDefault;
    _lsConfirmPassword.textField.textAlignment = NSTextAlignmentCenter;
    _lsConfirmPassword.textField.secureTextEntry = YES;
    _lsConfirmPassword.layer.zPosition = -1;
    [self.view addSubview:_lsConfirmPassword];
    
    
    /**
     *正式通过后，删除与下边4项有关的代码
     */
    self.password.hidden = YES;
    self.confirmPassword.hidden = YES;
    self.validationCode.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    _lsValidationCode.textField.text = @"";
//    _lsNePassword.textField.text = @"";
//    _lsConfirmPassword.textField.text = @"";
    [_lsValidationCode.textField resignFirstResponder];
    [_lsNePassword.textField resignFirstResponder];
    [_lsConfirmPassword.textField resignFirstResponder];
    
    [self.validationCode resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}

- (IBAction)updateAndLogin:(id)sender {
    //验证输入框
//    [[HttpRequestManager sharedManager] requestForgetPasswordWithData: completionHandle:^(id returnObject) {
//       
//        
//    } failed:^{
//        
//    } hitSuperView:];
    if ( ![[Message sharedManager] checkValidationCode:_lsValidationCode.textField.text] ) {
        return;
    }
    if ( ![[Message sharedManager] checkPassword:_lsNePassword.textField.text] ) {
        return;
    }
    if ( ![[Message sharedManager] checkPassword:_lsConfirmPassword.textField.text] ) {
        return;
    }

    [[HttpRequestManager sharedManager] requestSecretData:[self setUpParameters] interface:@"forgetPassword.json" completionHandle:^(id returnObject) {
        NSString *str = [[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *resultInfo = [returnDict categoryObjectForKey:@"resultInfo"];
        if ( [[Message sharedManager] checkReturnInfor:resultInfo] ) {
            [self saveUserInfoWithLocation:resultInfo];
            [self goToMainViewController];
//            LoginViewController *loginViewController = [[LoginViewController alloc] init];
//            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = loginViewController;
        }
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
    } hitSuperView:self.view];
}

- (NSData *)setUpParameters
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.mobileCode forKey:@"m"];
    [parameter setObject:_lsValidationCode.textField.text forKey:@"verifyCode"];
    [parameter setObject:_lsNePassword.textField.text forKey:@"newPassword"];
    [parameter setObject:_lsConfirmPassword.textField.text forKey:@"rePassword"];
    
    NSData *tmpDate = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *base64Str = [tmpDate base64EncodedString];
    
    NSData *base64Data = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
    return base64Data;
}

- (void)saveUserInfoWithLocation:(NSDictionary *)dict
{
    NSDictionary *patient = [dict categoryObjectForKey:@"patient"];
    NSString *name = [patient categoryObjectForKey:@"name"];
    NSNumber *patientID = [patient categoryObjectForKey:@"patientId"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *doctorID = [patient categoryObjectForKey:@"doctorId"];
    [userDef setObject:name forKey:@"name"];
    [userDef setObject:patientID forKey:PATIENTID_KEY];
    [userDef setObject:doctorID forKey:DOCTORID_KEY];
//    [userDef setObject:self.phoneNumber.text forKey:@"mobile"];
    [userDef synchronize];
}

- (void)goToMainViewController
{
//    UINavigationController *mainNavCtl = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithCategory:0]];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithCategory:0]];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - keyboard
-(void)willShowKeyboard:(NSNotification *)notification{
    //    NSLog(@"will show keyboard");
    if (!_lsValidationCode.textField.isFirstResponder) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        int keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        self.btnSubmit.frame = CGRectOffset(self.btnSubmit.frame, 0, keyboardHeight-_btnSubmitOriginalFrame.origin.y);
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
    [self resizeLayout:NO];

    [UIView commitAnimations];
}

- (void)resizeLayout:(BOOL)up {
    #define DREAM_FABS(ARG)  up?-fabs(ARG):fabs(ARG)
    
    _lsConfirmPassword.frame = CGRectOffset(_lsConfirmPassword.frame, 0, DREAM_FABS(self.btnSubmit.frame.origin.y-52-_lsConfirmPassword.frame.origin.y));
    _lsNePassword.frame = CGRectOffset(_lsNePassword.frame, 0, DREAM_FABS(_lsConfirmPassword.frame.origin.y-52-_lsNePassword.frame.origin.y));
    _lsValidationCode.frame = CGRectOffset(_lsValidationCode.frame, 0, DREAM_FABS(_lsNePassword.frame.origin.y-52-_lsValidationCode.frame.origin.y));
    
    ///////
    self.confirmPassword.frame = CGRectOffset(self.confirmPassword.frame, 0, DREAM_FABS(self.btnSubmit.frame.origin.y-52-self.confirmPassword.frame.origin.y));
    self.password.frame = CGRectOffset(self.password.frame, 0, DREAM_FABS(self.confirmPassword.frame.origin.y-52-self.password.frame.origin.y));
    
    self.validationCode.frame = CGRectOffset(self.validationCode.frame, 0, DREAM_FABS(self.password.frame.origin.y-52-self.validationCode.frame.origin.y));
    
    self.confirmPasswordLabel.frame = CGRectOffset(self.confirmPasswordLabel.frame, 0, self.confirmPassword.frame.origin.y-self.confirmPasswordLabel.frame.origin.y+8);
    self.passwordLabel.frame = CGRectOffset(self.passwordLabel.frame, 0, self.password.frame.origin.y-self.passwordLabel.frame.origin.y+8);
    self.validationCodeLabel.frame = CGRectOffset(self.validationCodeLabel.frame, 0, self.validationCode.frame.origin.y-self.validationCodeLabel.frame.origin.y+8);
    
    self.tipsLabel.frame = CGRectOffset(self.tipsLabel.frame, 0, self.validationCodeLabel.frame.origin.y - 64 -self.tipsLabel.frame.origin.y);
    self.tipsLabel.frame = CGRectOffset(self.tipsLabel.frame, 0, self.validationCodeLabel.frame.origin.y - 64 -self.tipsLabel.frame.origin.y);
    self.mobileLabel.frame = CGRectOffset(self.mobileLabel.frame, 0, self.tipsLabel.frame.origin.y - 28 -self.mobileLabel.frame.origin.y);
    self.mobileTipsLabel.frame = CGRectOffset(self.mobileTipsLabel.frame, 0, self.tipsLabel.frame.origin.y - 28 -self.mobileTipsLabel.frame.origin.y);
}
@end
