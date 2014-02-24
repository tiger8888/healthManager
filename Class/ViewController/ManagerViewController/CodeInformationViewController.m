//
//  CodeInformationViewController.m
//  HealthManager
//
//  Created by user on 14-2-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "CodeInformationViewController.h"
#import "MedinceCodeBusiness.h"
#import "MedinceCode.h"

@interface CodeInformationViewController ()
{
    MedinceCode *_medincecode;
}
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
    
    [[MedinceCodeBusiness sharedManager] request:self.codeStr completionHandle:^(MedinceCode *obj){
        //    NSString *webcontent = [[NSString alloc] initWithData:_tmpData encoding:NSUTF8StringEncoding];
        //    NSLog(@"data is %@", webcontent);
//           NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
//            MedinceCode *medinceCode = [MedinceCode new];
//           [parser setDelegate:medinceCode];
//        [parser parse];
        NSLog(@"data is :%@", obj.firstQueryTime);
        
    }failed:nil hitSuperView:self.view requestMethod:kGet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
