//
//  ForgetPasswordViewController.h
//  HealthManager
//
//  Created by PanPeng on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : BackButtonViewController
{
    LSTextField *_lsMobile;
}
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *mobile;

@end
