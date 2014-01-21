//
//  ModifyPasswordViewController.h
//  HealthManager
//
//  Created by user on 14-1-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : BackButtonViewController

@property (weak, nonatomic) IBOutlet UITextField *nePassword;
@property (weak, nonatomic) IBOutlet UITextField *validationCode;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;

- (IBAction)getValidationCode:(id)sender;
- (IBAction)submitOnClick:(id)sender;
- (IBAction)resetOnClick:(id)sender;
@end
