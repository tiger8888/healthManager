//
//  ForgetPasswordSetPWDViewController.h
//  HealthManager
//
//  Created by user on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordSetPWDViewController : NavigationBarViewController
- (IBAction)updateAndLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *validationCode;

@end
