//
//  ModifyPasswordViewController.h
//  HealthManager
//
//  Created by PanPeng on 14-1-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : BackButtonViewController<UITextFieldDelegate>
{
    LSTextField *_lsNePassword;
    LSTextField *_lsValidationCode;
    LSTextField *_lsConfirmPassword;
    LSTextField *_lsOldPassword;
}
@property (weak, nonatomic) IBOutlet UITextField *nePassword;
@property (weak, nonatomic) IBOutlet UITextField *validationCode;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UILabel *oldPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *nePasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *validatonCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnGetValidationCode;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

- (IBAction)getValidationCode:(id)sender;
- (IBAction)submitOnClick:(id)sender;
- (IBAction)resetOnClick:(id)sender;
@end
