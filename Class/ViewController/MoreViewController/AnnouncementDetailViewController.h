//
//  AnnouncementDetailViewController.h
//  HealthManager
//
//  Created by user on 14-1-17.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Announcement;

@interface AnnouncementDetailViewController : BackButtonViewController
@property (nonatomic, copy) Announcement *announcement;
@end
