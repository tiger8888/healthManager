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
    titleLabel.frame = CGRectMake(DEVICE_WIDTH/2, 44, DEVICE_WIDTH, 100);
    titleLabel.text = self.knowledgeModel.title;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = self.knowledgeModel.content;
    contentLabel.font = [UIFont systemFontOfSize:17];
    
    CGFloat contentLabelHeight;
    if ([self.knowledgeModel.content length]>0) {
        contentLabelHeight = [self.knowledgeModel.content sizeWithFont:[UIFont systemFontOfSize:17]].height;
    }
    else {
        contentLabelHeight = 40;
    }
    contentLabel.frame = CGRectMake(8, titleLabel.frame.size.height+10, DEVICE_WIDTH, contentLabelHeight);
    [self.view addSubview:titleLabel];
    [self.view addSubview:contentLabel];
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
