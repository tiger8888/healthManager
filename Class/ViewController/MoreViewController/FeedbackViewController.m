//
//  FeedbackViewController.m
//  HealthManager
//
//  Created by PanPeng on 14-1-22.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

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
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.layer.borderColor = [UIColor blueColor].CGColor;
    if ([self.textView.text isEqualToString:@"您的意见能帮助我们进一步改进产品的服务"]) {
        self.textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = @"您的意见能帮助我们进一步改进产品的服务";
    }
}
- (IBAction)submitOnClick:(id)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary new];

    NSString *patientId = [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY];
    NSString *feedbackUrl = [NSString stringWithFormat:@"suggest/%@.json", patientId];
    
    [parameters setObject:patientId forKey:@"patientId"];
    [parameters setObject:self.textView.text forKey:@"content"];
    
    [[HttpRequestManager sharedManager] requestWithParameters:parameters interface:feedbackUrl completionHandle:^(id returnObject) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        if ( [[Message sharedManager] checkReturnInfor:[dataDictionary objectForKey:@"resultInfo"]] ) {
            ALERT(@"提示信息", @"非常感谢您在百忙之中提出的好建议，希望您继续支持我们", @"确定");
        }
    } failed:^{
        
    } hitSuperView:self.view method:kPost];
}
@end
