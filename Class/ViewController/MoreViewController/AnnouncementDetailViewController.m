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
    titleLabel.frame = CGRectMake(20, 10, DEVICE_WIDTH - 40, 80);
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = self.announcement.title;
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize maximumLabelSizeOne = CGSizeMake(300,MAXFLOAT);
    CGSize expectedLabelSizeOne = [self.announcement.content sizeWithFont:font constrainedToSize:maximumLabelSizeOne lineBreakMode:NSLineBreakByCharWrapping];
    CGRect pointValueRect = CGRectMake(5, titleLabel.frame.size.height+10 ,DEVICE_WIDTH - 20, expectedLabelSizeOne.height);
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:pointValueRect];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    contentLabel.text = self.announcement.content;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FULLSCREEN];
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, expectedLabelSizeOne.height);
    
    [scrollView addSubview:titleLabel];
    [scrollView addSubview:contentLabel];
    [self.view addSubview:scrollView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
