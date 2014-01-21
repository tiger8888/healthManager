//
//  ForgetPasswordSetPWDViewController.m
//  HealthManager
//
//  Created by user on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ForgetPasswordSetPWDViewController.h"

@interface ForgetPasswordSetPWDViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.validationCode resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}

- (IBAction)updateAndLogin:(id)sender {
    //验证输入框
    [[HttpRequestManager sharedManager] requestForgetPasswordWithData:[self setUpParameters] completionHandle:^(id returnObject) {
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

- (NSData *)setUpParameters
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.mobileCode forKey:@"m"];
    [parameter setObject:self.validationCode.text forKey:@"verifyCode"];
    [parameter setObject:self.password.text forKey:@"newPassword"];
    [parameter setObject:self.confirmPassword.text forKey:@"rePassword"];
    
    NSData *tmpDate = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *base64Str = [tmpDate base64EncodedString];
    
    NSData *base64Data = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
    return base64Data;
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

@end
