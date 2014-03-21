//
//  ForgetPasswordSetPWDViewController.h
//  HealthManager
//
//  Created by PanPeng on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordSetPWDViewController : BackButtonViewController<UITextFieldDelegate>
{
    LSTextField *_lsNePassword;
    LSTextField *_lsValidationCode;
    LSTextField *_lsConfirmPassword;
}

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *validationCode;
@property (weak, nonatomic) IBOutlet UILabel *validationCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileTipsLabel;

@property (nonatomic, strong) NSString *mobileCode;

- (IBAction)updateAndLogin:(id)sender;
@end
