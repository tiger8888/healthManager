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
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = self.announcement.title;
    
    UIFont *contentFont = [UIFont systemFontOfSize:15.0];
    int contentSizeWidth = DEVICE_WIDTH-20;
    
//    CGSize contentSize = CGSizeMake(contentSizeWidth, CGFLOAT_MAX);
//    
//    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.announcement.content attributes:@{NSFontAttributeName:contentFont}];
//    CGRect contentRect = [attributedText boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    
//    CGRect contentFrame = CGRectMake(10, titleLabel.frame.size.height+10 ,contentSizeWidth , ceilf(contentRect.size.height*1.3));
    
//    UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentFrame];
//    contentLabel.numberOfLines = 0;
//    contentLabel.lineBreakMode = UILineBreakModeWordWrap;
//    contentLabel.text = self.announcement.content;
    
    UILabel *contentLabel = [[ViewBuilder sharedManager] LabelWithMultiLinesFitHeight:self.announcement.content withLeft:10 withTop:titleLabel.frame.size.height+10 withWidth:contentSizeWidth withFont:contentFont];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FULLSCREEN];
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, titleLabel.frame.size.height+contentLabel.frame.size.height);
    
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
