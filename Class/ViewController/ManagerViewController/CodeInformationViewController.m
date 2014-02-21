//
//  CodeInformationViewController.m
//  HealthManager
//
//  Created by user on 14-2-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "CodeInformationViewController.h"

@interface CodeInformationViewController ()

@end

@implementation CodeInformationViewController

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
    NSLog(@"code string = %@", self.codeStr);
    
    UIWebView *webView = [UIWebView new];
    if (IS_IOS7) {
        webView.frame = CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT-44-20-20);
    }
    else {
        webView.frame = CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT-20);
    }
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"/CodeFlowInfo/codeflow" ofType:@"html"];
    NSString *webViewHtml = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:webViewHtml baseURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/CodeFlowInfo"]  ]];
    [webViewHtml stringByReplacingOccurrencesOfString:@"pan" withString:@"dream"];
    [webView stringByEvaluatingJavaScriptFromString:webViewHtml];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
