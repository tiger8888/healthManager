//
//  SessionViewController.m
//  HealthManager
//
//  Created by 李硕 on 2014/01/15.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SessionViewController.h"
#import "SessionMessageStyleManager.h"
#import "SessionMessageSqlite.h"


@interface SessionViewController ()

@end

static BOOL isLoadAllSession = FALSE;

@implementation SessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        autoRefreshTimer =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getDoctorSessionInfo:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isLoadAllSession = FALSE;
    if (IS_IOS7) {
        self.webView.frame = CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT-44-20-20-20-20);
        [self.toolBar setFrame:CGRectMake(0, DEVICE_HEIGHT - 44-20-20, DEVICE_WIDTH, 44)];
    }
    else {
        self.webView.frame = CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT-20);
    }
    
    [self addRefreshButtonOnNavigation];
    
    [[SessionMessageStyleManager sharedInstance] loadTemplate];
    _styleArray = [[SessionMessageStyleManager sharedInstance] availableVariants];
    [self.webView loadHTMLString:[SessionMessageStyleManager sharedInstance].baseHTML baseURL:[SessionMessageStyleManager sharedInstance].baseURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard) name:UIKeyboardWillHideNotification object:nil];
    
    [self getDoctorInfo];
//    _titleLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"doctorName"] stringByAppendingString: @"医生"];
//    NSLog(@"view did load");
//    void (^aaaa)(void) = ^{
//        [self getAllSessionInfo];
//    };
//    aaaa();
    
//    NSTimer *timer;
//    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getDoctorSessionInfo) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [autoRefreshTimer setFireDate:[NSDate distantPast]];
//        NSLog(@"view will appear");
//    self.textField.text = @"auto write session message";
//    [self submitOkClick:Nil];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [autoRefreshTimer setFireDate:[NSDate distantFuture]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SessionMessageSqlite sharedManager] closeDB];
}

#pragma mark - Event Method
- (void)backButtonClick
{
    NSLog(@"back");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)appendMessage:(SessionMessage *)msg {
    NSString *appendScript = [[SessionMessageStyleManager sharedInstance] appendScriptForMessage:msg];
//    NSLog(@"webView content is :%@",appendScript);
    [self.webView stringByEvaluatingJavaScriptFromString:appendScript];
}

- (IBAction)submitOkClick:(id)sender {
    if ( !_sessionMessage ) {
        _sessionMessage = [SessionMessage new];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _sessionMessage.id = 0;
    _sessionMessage.senderId = [[userDefault objectForKey:PATIENTID_KEY] intValue];
    _sessionMessage.senderName = [userDefault objectForKey:@"name"];
    _sessionMessage.sendType = SessionMessageSendTypeMe;
    _sessionMessage.content = self.textField.text ? self.textField.text : @" ";
    _sessionMessage.timeStamp = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                               dateStyle:NSDateFormatterShortStyle
                                               timeStyle:NSDateFormatterShortStyle];
    
    if ( ![[Message sharedManager] checkSessionMessage:self.textField.text] ) {
        return;
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:[userDefault objectForKey:DOCTORID_KEY] forKey:@"doctorId"];
    [parameter setObject:self.textField.text forKey:@"msg"];
    
    NSString *interfaceUrl = [NSString stringWithFormat:@"chat/patient/add/%d.json", _sessionMessage.senderId];
    
    [[HttpRequestManager sharedManager] requestWithParameters:parameter interface:interfaceUrl completionHandle:^(id returnObject) {
//        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
//        NSString *result = [[dataDictionary objectForKey:@"resultInfo"] objectForKey:@"retCode"];
//        NSLog(@"code=%@", result);
        
        [[SessionMessageSqlite sharedManager] insertOne:_sessionMessage];
        [self appendMessage:_sessionMessage];
        
        [self.textField resignFirstResponder];
        self.textField.text = nil;
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
    } hitSuperView:self.view method:kPost];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)getDoctorInfo {
    NSString *interfaceUrl = [NSString stringWithFormat:@"patient/doctor/%@.json", [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY]];
    NSLog(@"get doctorinfo interface url is :%@", interfaceUrl);
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:interfaceUrl completionHandle:^(id returnObject) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *result = [dataDictionary objectForKey:@"resultInfo"];
        if ( [[Message sharedManager] checkReturnInformationWithInterface:result] ) {
            NSDictionary *doctorInfo = [result objectForKey:@"doctor"];
            NSString *doctorImage = [doctorInfo objectForKey:@"picUrl"];
            [[NSUserDefaults standardUserDefaults] setObject: [doctorInfo objectForKey:@"name"] forKey:@"doctorName"];
            [[NSUserDefaults standardUserDefaults] setObject:doctorImage forKey:@"doctorImage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            _titleLabel.text = [[doctorInfo objectForKey:@"name"] stringByAppendingString: @"医生"];
//            [self getAllSessionInfo];
            [self getDoctorSessionInfo:nil];
            
        }
        
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
        NSLog(@"error in method name: %s", __FUNCTION__);
    } hitSuperView:self.view method:kGet];
}

- (void)getDoctorSessionInfo:(id)sender {
    UIView * hitSuperView;
    if ( [sender isKindOfClass:[UIButton class]] ) {
        hitSuperView = self.view;
//        NSLog(@"exist refresh view");
    }
    else {
        hitSuperView = nil;
//        NSLog(@"no refresh view");
    }
    if (isLoadAllSession  == FALSE) {
        [self getAllSessionInfo];
    }
    NSString *interfaceUrl = [NSString stringWithFormat:@"chat/list/%@.json", [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY]];
    
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:interfaceUrl completionHandle:^(id returnObject) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *result = [dataDictionary objectForKey:@"resultInfo"];
        if ( [[Message sharedManager] checkReturnInformationWithInterface:result] ) {
            NSArray *sessionMessageInfoArray = [result objectForKey:@"list"];
            SessionMessage *sessionMsg = [SessionMessage new];
            for (NSDictionary *msgItem in sessionMessageInfoArray ) {
                sessionMsg.id = 0;
                sessionMsg.senderId = [[msgItem objectForKey:@"doctorId"] intValue];
                sessionMsg.senderName = [msgItem objectForKey:@"doctorName"];
                sessionMsg.sendType = SessionMessageSendTypeOther;
                sessionMsg.content = [msgItem objectForKey:@"msg"];
                sessionMsg.timeStamp = [msgItem objectForKey:@"createTime"];
                
                [[SessionMessageSqlite sharedManager] insertOne:sessionMsg];
                [self appendMessage:sessionMsg];
            }
        }
        
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
    } hitSuperView:hitSuperView method:kGet];
}

- (void)getAllSessionInfo {
    NSArray *sessionMsgArr = [[SessionMessageSqlite sharedManager] queryAll];
    for (SessionMessage *msgItem in sessionMsgArr) {
        [self appendMessage:msgItem];
    }
    isLoadAllSession = TRUE;
}

- (void)addRefreshButtonOnNavigation {
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(DEVICE_WIDTH - 54, 0, 44, 44);
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(getDoctorSessionInfo:) forControlEvents:UIControlEventTouchUpInside];
    
//    [refreshBtn addTarget:self action:@selector(getAllSessionInfo) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:refreshBtn];
}


#pragma mark - keyboard
-(void)willShowKeyboard:(NSNotification *)notification{
//    NSLog(@"will show keyboard");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    int keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.toolBar setFrame:CGRectMake(0,DEVICE_HEIGHT-keyboardHeight-44-20, DEVICE_WIDTH, 44)];
    [UIView commitAnimations];
}
-(void)willHideKeyboard{
//    NSLog(@"will hide keyboard");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [self.toolBar setFrame:CGRectMake(0, DEVICE_HEIGHT - 44-20, DEVICE_WIDTH, 44)];
    [UIView commitAnimations];
}
@end
