//
//  InputCodeViewController.h
//  HealthManager
//
//  Created by user on 14-2-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCodeViewController : BackButtonViewController
- (IBAction)clickSubmit:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *codeText;

@end
