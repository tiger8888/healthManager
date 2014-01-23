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
    titleLabel.frame = CGRectMake(20, 10, DEVICE_WIDTH - 40, 80);
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = self.knowledgeModel.title;
    
    UIFont *contentFont = [UIFont systemFontOfSize:15.0];
    int contentSizeWidth = DEVICE_WIDTH-20;
    CGRect contentFrame = CGRectMake(10, titleLabel.frame.size.height+10 ,contentSizeWidth , 0);

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentFrame];
    contentLabel.font = contentFont;
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    contentLabel.text = self.knowledgeModel.content;
    [contentLabel fitHeight];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FULLSCREEN];
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, titleLabel.frame.size.height+contentLabel.frame.size.height+20);
    
    [scrollView addSubview:titleLabel];
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
