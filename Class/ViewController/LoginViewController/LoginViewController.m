//
//  LoginViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-11-29.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [self layoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background"]];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint p = [touch locationInView:self.view];
    NSLog(@"%f %f",p.x,p.y);
    [self.phoneNumber resignFirstResponder];
    [self.password resignFirstResponder];
}

- (IBAction)onClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
//    UINavigationController *mainNavCtl;
    switch (button.tag) {
        case 1:
        {
            NSLog(@"登陆");
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
            [parameter setObject:@"13911011342" forKey:@"m"];
            [parameter setObject:@"666666" forKey:@"p"];
            

//            [parameter setObject:_phoneNumber.text forKey:@"m"];
//            [parameter setObject:_password.text forKey:@"p"];
                /**
                 *  请求方法：
                 *  首先找出单例
                 *  @param  字典就是要传的json格式的参数
                 *  @param  字符串就是你要请求的接口
                 *  @param  block是你回调的方法
                 *  @param  block是请求失败（无网络）你回调的方法
                 *  @param  提示框的父视图，一般为self.view如果不添加提示就nil
                 *  @return 不需要返回值
                 */
            [[HttpRequestManager sharedManager] requestWithParameters:parameter interface:@"login.json" completionHandle:^(id jsonObject) {
                
                NSString *str = [[NSString alloc] initWithData:jsonObject encoding:NSUTF8StringEncoding];
                NSLog(@"%@",str);
                
            } failed:^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"网络连接失败，请检查网络稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
            } hitSuperView:self.view method:kPost];
        }
            break;
        case 2:
        {
            NSLog(@"忘记密码");
        }
            break;
        default:
            break;
    }
    
//    mainNavCtl = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithCategory:0]];
//    [self presentViewController:mainNavCtl animated:YES completion:NULL];
    
}
@end
