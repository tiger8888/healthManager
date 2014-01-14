//
//  SettingRemindTimeViewController.h
//  HealthManager
//
//  Created by user on 14-1-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingRemindTimeViewController : SuperListViewController
@property (nonatomic, strong) NSString *selectedValue;
@property (nonatomic, copy) void (^dismissBlock)(NSString * time);
@end
