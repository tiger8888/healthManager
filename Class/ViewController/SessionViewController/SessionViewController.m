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
#import "DoctorBusiness.h"


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
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
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
    
    [[DoctorBusiness sharedManager] setMyDoctorInfoSync];
    _titleLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:DOCTOR_NAME_KEY] stringByAppendingString: @"医生"];
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
    [self.webView stringByEvaluatingJavaScriptFromString:appendScript];
}

- (IBAction)submitOkClick:(id)sender {
    if ( !_sessionMessage ) {
        _sessionMessage = [SessionMessage new];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _sessionMessage.id = 0;
    _sessionMessage.senderId = [[userDefault objectForKey:PATIENTID_KEY] intValue];
    _sessionMessage.patientId = [[userDefault objectForKey:PATIENTID_KEY] intValue];
    _sessionMessage.doctorId = [[userDefault objectForKey:DOCTORID_KEY] intValue];
    _sessionMessage.senderName = [userDefault objectForKey:@"name"];
    _sessionMessage.sendType = SessionMessageSendTypeMe;
    _sessionMessage.content = self.textField.text ? self.textField.text : @" ";
    _sessionMessage.timeStamp = [dateFormater stringFromDate:[NSDate date]];
    
    if ( ![[Message sharedManager] checkSessionMessage:self.textField.text] ) {
        return;
    }
    [[DoctorBusiness sharedManager] sendSessionMessageToMydoctor:_sessionMessage withBlock:
    ^{
        [self appendMessage:_sessionMessage];
        
        [self.textField resignFirstResponder];
        self.textField.text = nil;
    } superView:self.view];
//    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
//    [parameter setObject:[userDefault objectForKey:DOCTORID_KEY] forKey:@"doctorId"];
//    [parameter setObject:self.textField.text forKey:@"msg"];
//    
//    NSString *interfaceUrl = [NSString stringWithFormat:@"chat/patient/add/%d.json", _sessionMessage.senderId];
//    
//    [[HttpRequestManager sharedManager] requestWithParameters:parameter interface:interfaceUrl completionHandle:^(id returnObject) {
//        
//        [[SessionMessageSqlite sharedManager] insertOne:_sessionMessage];
//        [self appendMessage:_sessionMessage];
//        
//        [self.textField resignFirstResponder];
//        self.textField.text = nil;
//    } failed:^{
//        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
//    } hitSuperView:self.view method:kPost];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    [[DoctorBusiness sharedManager] getMyDoctorSessionInfo:^(SessionMessage *msg) {
        [self appendMessage:msg];
    } withSuperView:hitSuperView];
    
//    NSString *interfaceUrl = [NSString stringWithFormat:@"chat/list/%@.json", [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY]];
//    
//    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:interfaceUrl completionHandle:^(id returnObject) {
//        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary *result = [dataDictionary objectForKey:@"resultInfo"];
//        if ( [[Message sharedManager] checkReturnInformationWithInterface:result] ) {
//            NSArray *sessionMessageInfoArray = [result objectForKey:@"list"];
//            SessionMessage *sessionMsg = [SessionMessage new];
//            sessionMsg.patientId = [[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY] intValue];
//            
//            for (NSDictionary *msgItem in sessionMessageInfoArray ) {
//                sessionMsg.id = 0;
//                sessionMsg.senderId = [[msgItem objectForKey:@"doctorId"] intValue];
//                sessionMsg.doctorId = [[msgItem objectForKey:@"doctorId"] intValue];
//                sessionMsg.senderName = [msgItem objectForKey:@"doctorName"];
//                sessionMsg.sendType = SessionMessageSendTypeOther;
//                sessionMsg.content = [msgItem objectForKey:@"msg"];
//                sessionMsg.timeStamp = [msgItem objectForKey:@"createTime"];
//                
//                [[SessionMessageSqlite sharedManager] insertOne:sessionMsg];
//                [self appendMessage:sessionMsg];
//            }
//        }
//        
//    } failed:^{
//        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
//    } hitSuperView:hitSuperView method:kGet];
}

- (void)getAllSessionInfo {
    NSArray *sessionMsgArr = [[DoctorBusiness sharedManager] getMyDoctorAllSessionInfo];
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
