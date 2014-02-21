//
//  MedinceAddViewController.h
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedinceAddViewController : NavigationBarViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
- (IBAction)cancel:(id)sender;

- (IBAction)clickSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *medicineName;

@end
