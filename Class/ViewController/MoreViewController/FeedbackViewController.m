//
//  FeedbackViewController.m
//  HealthManager
//
//  Created by PanPeng on 14-1-22.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
{
    UITextView *_textView;
}
@end

@implementation FeedbackViewController

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
    _textView = [[UITextView alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    _textView.layer.borderColor = UICOLORFROMRGB(0xcccccc).CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 10;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.showsVerticalScrollIndicator = YES;
    _textView.delegate = self;
    _textView.frame = CGRectMake(20, 88, 280, 100);
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _textView.layer.borderColor = UICOLORFROMRGB(0x39b3d2).CGColor;
    _textView.layer.borderWidth = 3;
    if (_textView.text == NULL) {
        _textView.text = @"您的意见能帮助我们进一步改进产品的服务";
    }
    if ([_textView.text isEqualToString:@"您的意见能帮助我们进一步改进产品的服务"]) {
        _textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    if ([_textView.text isEqualToString:@""]) {
        _textView.text = @"您的意见能帮助我们进一步改进产品的服务";
    }
}
- (IBAction)submitOnClick:(id)sender {
    if ([_textView.text isEqualToString:@""]) {
        ALERT(@"", @"还请多给点建议。", @"");
        return;
    }
    NSString *feedbackContent = _textView.text;
    feedbackContent = [feedbackContent stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if ([feedbackContent isEqualToString:@""]) {
        ALERT(@"", @"还请多给点建议。", @"");
        _textView.text = @"";
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];

    NSString *patientId = [[UserBusiness sharedManager] getCurrentPatientID];
    NSString *feedbackUrl = [NSString stringWithFormat:@"suggest/%@.json", patientId];
    
    [parameters setObject:patientId forKey:@"patientId"];
    [parameters setObject:_textView.text forKey:@"content"];
    
    [[HttpRequestManager sharedManager] requestWithParameters:parameters interface:feedbackUrl completionHandle:^(id returnObject) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        if ( [[Message sharedManager] checkReturnInfor:[dataDictionary objectForKey:@"resultInfo"]] ) {
            ALERT(@"提示信息", @"非常感谢您在百忙之中提出的好建议，希望您继续支持我们", @"确定");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^{
        
    } hitSuperView:self.view method:kPost];
}

#pragma mark - keyboard
-(void)willShowKeyboard:(NSNotification *)notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    int keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    float btnSubmitTop = DEVICE_HEIGHT - keyboardHeight - 60;

    self.btnSubmit.frame = CGRectMake(self.btnSubmit.frame.origin.x, btnSubmitTop, self.btnSubmit.frame.size.width, self.btnSubmit.frame.size.height);
    _textView.frame = CGRectMake(20, 88, 280, self.btnSubmit.frame.origin.y - 20-_textView.frame.origin.y);
    
    [UIView commitAnimations];
}
@end
