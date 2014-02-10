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
    titleLabel.frame = CGRectMake(20, 10, DEVICE_WIDTH - 40, 80);
    titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
    titleLabel.text = self.announcement.title;
    
    UIFont *contentFont = [UIFont systemFontOfSize:15.0];
    int contentSizeWidth = DEVICE_WIDTH-20;
    CGRect contentFrame = CGRectMake(10, titleLabel.frame.size.height+10 ,contentSizeWidth , 0);
    
    /**
     *第一种创建自适应高度label的方法，个人认为上种方法更灵活一些，但性能方面不知道哪个更好一些
     */
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentFrame];
    contentLabel.font = contentFont;
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap;
    contentLabel.text = self.announcement.content;
    [contentLabel fitHeight];
    
    /**
     *第二种创建自适应高度label的方法
     */
//    UILabel *contentLabel = [[ViewBuilder sharedManager] LabelWithMultiLinesFitHeight:self.announcement.content withLeft:10 withTop:titleLabel.frame.size.height+10 withWidth:contentSizeWidth withFont:contentFont];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FULLSCREEN];
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, titleLabel.frame.size.height+contentLabel.frame.size.height+20);
    
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
