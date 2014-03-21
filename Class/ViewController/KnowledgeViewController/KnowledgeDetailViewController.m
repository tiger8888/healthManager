//
//  KnowledgeDetailViewController.m
//  HealthManager
//
//  Created by 潘朋 on 14-1-9.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import "KnowledgeDetailViewController.h"
//#import "KnowledgeStore.h"

@interface KnowledgeDetailViewController()

@end

@implementation KnowledgeDetailViewController
@synthesize knowledgeModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showContentOnWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Layout Method
- (void)showContentOnWebView
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(20, 10, DEVICE_WIDTH - 40, 20);
    titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = self.knowledgeModel.title;
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.frame = CGRectMake((DEVICE_WIDTH-160)/2, 30, 160, 20);
    timeLabel.textColor = UICOLORFROMRGB(0x666666);
    timeLabel.text = self.knowledgeModel.time;
    
    UILabel *separateLine = [UILabel new];
    separateLine.backgroundColor = UICOLORFROMRGB(0xc9c9c9);
    separateLine.frame = CGRectMake(10, 60, DEVICE_WIDTH-20, 1);
    
    UIFont *contentFont = [UIFont systemFontOfSize:16.0];
    int contentSizeWidth = DEVICE_WIDTH-20;
    CGRect contentFrame = CGRectMake(10, 80 ,contentSizeWidth , 0);

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentFrame];
    contentLabel.font = contentFont;
    contentLabel.textAlignment =
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap;
    contentLabel.text = self.knowledgeModel.content;
    [contentLabel fitHeight:40.0];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FULLSCREEN];
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, titleLabel.frame.size.height+contentLabel.frame.size.height+20);
    
    [scrollView addSubview:titleLabel];
    [scrollView addSubview:timeLabel];
    [scrollView addSubview:separateLine];
    [scrollView addSubview:contentLabel];
    [self.view addSubview:scrollView];
}

#pragma mark - WebView Delegate Method

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    _activityIndicatorLoading.hidden = false;
//    [_activityIndicatorLoading startAnimating];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    _activityIndicatorLoading.hidden = false;
//    [_activityIndicatorLoading stopAnimating];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
