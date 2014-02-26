//
//  MedinceAddViewController.h
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedinceAddViewController : BackButtonViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
- (IBAction)cancel:(id)sender;

- (IBAction)clickSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *medicineName;
@property (nonatomic, copy) void(^block)(void);
@property (weak, nonatomic) IBOutlet UILabel *medicineNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@end
