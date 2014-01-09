//
//  KnowledgeDetailViewController.m
//  HealthManager
//
//  Created by 潘朋 on 14-1-9.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import "KnowledgeDetailViewController.h"
#import "KnowledgeStore.h"

@interface KnowledgeDetailViewController()
{
    UIWebView *_webView;
    UIActivityIndicatorView *_activityIndicatorLoading;
}
@end

@implementation KnowledgeDetailViewController
@synthesize url;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.url) {
        _activityIndicatorLoading = [UIActivityIndicatorView new];
        _activityIndicatorLoading.frame = CGRectMake(_backButtonItem.frame.size.width, (_navigationBar.frame.size.height-32)/2, 32, 32);
        _activityIndicatorLoading.hidden = YES;
        [_navigationBar addSubview:_activityIndicatorLoading];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        _webView = [[UIWebView alloc] initWithFrame:FULLSCREEN];
        _webView.delegate = self;
        [_webView loadRequest:request];
        
        [self.view addSubview:_webView];
    }
    else {
        //因url参数传递问题，提示有好信息
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"暂无信息" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate Method

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _activityIndicatorLoading.hidden = false;
    [_activityIndicatorLoading startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _activityIndicatorLoading.hidden = false;
    [_activityIndicatorLoading stopAnimating];
}
@end
