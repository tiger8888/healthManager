//
//  ForgetPasswordViewController.h
//  HealthManager
//
//  Created by user on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : BackButtonViewController
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *mobile;

@end
