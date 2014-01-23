//
//  ForgetPasswordSetPWDViewController.h
//  HealthManager
//
//  Created by PanPeng on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordSetPWDViewController : BackButtonViewController


@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *validationCode;

@property (nonatomic, strong) NSString *mobileCode;

- (IBAction)updateAndLogin:(id)sender;
@end
