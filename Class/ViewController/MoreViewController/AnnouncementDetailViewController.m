//
//  AnnouncementDetailViewController.m
//  HealthManager
//
//  Created by PanPeng on 14-1-17.
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
    titleLabel.frame = CGRectMake(20, 10, DEVICE_WIDTH - 40, 20);
    titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = self.announcement.title;
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.frame = CGRectMake(DEVICE_WIDTH-200, 30, 160, 20);
    timeLabel.textColor = UICOLORFROMRGB(0x666666);
    timeLabel.text = self.announcement.time;
    
    UILabel *separateLine = [UILabel new];
    separateLine.backgroundColor = UICOLORFROMRGB(0xc9c9c9);
    separateLine.frame = CGRectMake(10, 60, DEVICE_WIDTH-20, 1);
    
    UIFont *contentFont = [UIFont systemFontOfSize:15.0];
    int contentSizeWidth = DEVICE_WIDTH-20;
    CGRect contentFrame = CGRectMake(10, 80 ,contentSizeWidth , 0);
    
    /**
     *第一种创建自适应高度label的方法，个人认为上种方法更灵活一些，但性能方面不知道哪个更好一些
     */
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentFrame];
    contentLabel.font = contentFont;
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap;
    contentLabel.text = self.announcement.content;
    [contentLabel fitHeight:40.0];
    
    /**
     *第二种创建自适应高度label的方法
     */
//    UILabel *contentLabel = [[ViewBuilder sharedManager] LabelWithMultiLinesFitHeight:self.announcement.content withLeft:10 withTop:titleLabel.frame.size.height+10 withWidth:contentSizeWidth withFont:contentFont];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FULLSCREEN];
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, titleLabel.frame.size.height+contentLabel.frame.size.height+20);
    
    [scrollView addSubview:titleLabel];
    [scrollView addSubview:timeLabel];
    [scrollView addSubview:separateLine];
    [scrollView addSubview:contentLabel];
    [self.view addSubview:scrollView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
