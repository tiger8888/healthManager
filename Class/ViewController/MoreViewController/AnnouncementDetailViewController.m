//
//  AnnouncementDetailViewController.m
//  HealthManager
//
//  Created by user on 14-1-17.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "AnnouncementDetailViewController.h"
#import "Announcement.h"

@interface AnnouncementDetailViewController ()

@end

@implementation AnnouncementDetailViewController
@synthesize announcement;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(DEVICE_WIDTH/2, 44, DEVICE_WIDTH, 100);
    titleLabel.text = self.announcement.title;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = self.announcement.content;
    contentLabel.font = [UIFont systemFontOfSize:17];
    
    CGFloat contentLabelHeight;
    if ([self.announcement.content length]>0) {
        contentLabelHeight = [self.announcement.content sizeWithFont:[UIFont systemFontOfSize:17]].height;
    }
    else {
        contentLabelHeight = 40;
    }
    contentLabel.frame = CGRectMake(8, titleLabel.frame.size.height+10, DEVICE_WIDTH, contentLabelHeight);
    [self.view addSubview:titleLabel];
    [self.view addSubview:contentLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
