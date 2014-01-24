//
//  SessionViewController.m
//  HealthManager
//
//  Created by 李硕 on 2014/01/15.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SessionViewController.h"
#import "SessionMessageStyleManager.h"

@interface SessionViewController ()

@end

@implementation SessionViewController

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
	// Do any additional setup after loading the view.
    self.webView.frame = CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT);
    [[SessionMessageStyleManager sharedInstance] loadTemplate];
    _styleArray = [[SessionMessageStyleManager sharedInstance] availableVariants];
    [self.webView loadHTMLString:[SessionMessageStyleManager sharedInstance].baseHTML baseURL:[SessionMessageStyleManager sharedInstance].baseURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard) name:UIKeyboardWillHideNotification object:nil];
    
    [self getDoctorInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _sessionMessage.senderId = [[userDefault objectForKey:@"patientId"] intValue];
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
    NSLog(@"doctor id is :%@", [userDefault objectForKey:DOCTORID_KEY]);
    [parameter setObject:[userDefault objectForKey:DOCTORID_KEY] forKey:@"doctorId"];
    [parameter setObject:self.textField.text forKey:@"msg"];
    
    NSString *interfaceUrl = [NSString stringWithFormat:@"chat/patient/add/%d.json", _sessionMessage.senderId];
    
    [[HttpRequestManager sharedManager] requestWithParameters:parameter interface:interfaceUrl completionHandle:^(id returnObject) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSString *result = [[dataDictionary objectForKey:@"resultInfo"] objectForKey:@"retCode"];
        NSLog(@"code=%@", result);
        
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
    
}

#pragma mark - keyboard
-(void)willShowKeyboard:(NSNotification *)notification{
    NSLog(@"will show keyboard");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    int keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.toolBar setFrame:CGRectMake(0,DEVICE_HEIGHT-keyboardHeight-44-20, DEVICE_WIDTH, 44)];
    [UIView commitAnimations];
}
-(void)willHideKeyboard{
    NSLog(@"will hide keyboard");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [self.toolBar setFrame:CGRectMake(0, DEVICE_HEIGHT - 44-20, DEVICE_WIDTH, 44)];
    [UIView commitAnimations];
}
@end
