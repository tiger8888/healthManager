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
    NSString *_webViewHtml;
}
@end

@implementation CodeInformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _webViewHtml = @"";
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
    _webViewHtml = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    
    
    [[MedinceCodeBusiness sharedManager] request:self.codeStr completionHandle:^(MedinceCode *obj){
        if (obj.name) {
            _webViewHtml = [_webViewHtml stringByReplacingOccurrencesOfString:@"DREAM-NAME" withString:obj.name];
        }
        if (obj.outputCompany) {
            _webViewHtml = [_webViewHtml stringByReplacingOccurrencesOfString:@"DREAM-COMPANY" withString:obj.outputCompany];
        }
        if (obj.approvalNumber) {
        _webViewHtml = [_webViewHtml stringByReplacingOccurrencesOfString:@"DREAM-NUMBER" withString:obj.approvalNumber];
        }
        if (obj.outputDate) {
        _webViewHtml = [_webViewHtml stringByReplacingOccurrencesOfString:@"DREAM-DATE" withString:obj.outputDate];
        }
        if (obj.validExpire) {
            _webViewHtml = [_webViewHtml stringByReplacingOccurrencesOfString:@"DREAM-EXPIRE" withString:[self computeExpire:obj]];
        }
        if (self.codeStr) {
        _webViewHtml = [_webViewHtml stringByReplacingOccurrencesOfString:@"DREAM-CODE" withString:self.codeStr];
        }
        if (obj.circulationUnit) {
        _webViewHtml = [_webViewHtml stringByReplacingOccurrencesOfString:@"DREAM-RECEIVE" withString:obj.circulationUnit];
        }
        [webView loadHTMLString:_webViewHtml baseURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/CodeFlowInfo"]  ]];
        [_webViewHtml stringByReplacingOccurrencesOfString:@"pan" withString:@"dream"];
        [webView stringByEvaluatingJavaScriptFromString:_webViewHtml];
        [self.view addSubview:webView];
        
    }failed:nil hitSuperView:self.view requestMethod:kGet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)computeExpire:(MedinceCode *)obj {
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    outputDateFormatter.dateFormat = @"yyyy年mm月dd日";
    NSDateFormatter *overdueDateFormatter = [NSDateFormatter new];
    overdueDateFormatter.dateFormat = @"yyyymmdd";
    
    double timeDiff = [[overdueDateFormatter dateFromString:obj.validExpire] timeIntervalSinceDate:[outputDateFormatter dateFromString:obj.outputDate]];
    NSLog(@"time diff = %f",timeDiff);
    
    NSString *timeLittle = [NSString stringWithFormat:@"%@", [outputDateFormatter dateFromString:obj.outputDate]];
    NSString *yearBig = [obj.validExpire substringToIndex:4];
    NSString *yearLittle = [timeLittle substringToIndex:4];
//    NSLog(@"yearBig=%@, yearLittle=%@",yearBig,yearLittle);
    int yearDiff = [yearBig intValue] - [yearLittle intValue];
    if (yearDiff>0) {
        return [NSString stringWithFormat:@"%d年", yearDiff];
    }
    else {
        // 1day = 86400 1month = 2592000(30day)
        return @"";
    }
}

@end
