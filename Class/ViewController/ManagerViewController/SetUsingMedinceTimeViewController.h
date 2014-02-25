//
//  SetUsingMedinceTimeViewController.h
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedinceRemindTimeModel.h"

@interface SetUsingMedinceTimeViewController : BackButtonViewController
- (IBAction)clickDelete:(id)sender;
- (IBAction)clickSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (nonatomic, copy) void(^block)(void);

@property (nonatomic, strong) NSManagedObject *medince;
@end
