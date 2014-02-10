//
//  MainViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-11-29.
//
//

#import "MainViewController.h"
#import "AlertRecordModel.h"
#import "AlertRecordManager.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)buttonClick:(id)sender;

@end

@implementation MainViewController

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
    _nameLabel.text = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
        _nameLabel.text = [@"你好，" stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
    }
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *patientID = [userDef objectForKey:PATIENTID_KEY];
    if (!patientID || [patientID intValue] == 0)
    {
        LoginViewController *loginVC =[[LoginViewController alloc] init];
        loginVC.delegate = self;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:^{
            
        }];
    }
    
    [self checkAlertMessage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSString *interfaceUrl = [NSString stringWithFormat:@"warn/list/%d.json", [[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY] intValue]];
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:interfaceUrl completionHandle:^(id returnObject) {
        NSLog(@"announcement data is : %@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        if ([[returnDict objectForKey:@"retCode"] intValue] == 3) {
            return ;
        }
        NSArray *list = [[returnDict objectForKey:@"retMessage"] objectForKey:@"list"];
        for (id x in list) {
            AlertRecordModel *model = [[AlertRecordModel alloc] initWithDict:x];
            [[AlertRecordManager sharedManager] addOne:model];
        }
        
        [self refreshBadgeView];
    } failed:^{
        
    } hitSuperView:nil method:kGet];
    
    [self refreshBadgeView];
    [self checkAlertMessage];
}


- (IBAction)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 2) {
        NSString *myDoctorID = [self getCurrentDoctorID];
        if (!myDoctorID || [myDoctorID intValue] == 0)
        {
            [self goToFunctionPart:2];
        }
        else
        {
            [self goToFunctionPart:9];
        }
        return;
    }
    [self goToFunctionPart:button.tag];
}

- (void)goToFunctionPart:(NSUInteger)category
{
    NSString *classStr = [[[(AppDelegate *)([UIApplication sharedApplication].delegate) propertyList] objectAtIndex:category] objectForKey:@"class"];
    Class class = NSClassFromString(classStr);
    UIViewController * viewController = [[class alloc] initWithCategory:category];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Delegate Method
- (void)loginComplate
{
    _nameLabel.text = nil;

    _nameLabel.text = [@"你好，" stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
    
    [self checkAlertMessage];
}

#pragma mark - Other Method
- (void)refreshBadgeView
{
    NSArray *alerts = [[AlertRecordManager sharedManager] fetchUnread];
    if (alerts.count != 0) {
        UIView *superView = [self.view viewWithTag:3];
        
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:superView alignment:JSBadgeViewAlignmentTopCenter];
        badgeView.badgeText = [NSString stringWithFormat:@"%d",alerts.count];
        //    badgeView.transform = CGAffineTransformMakeScale(1,1);
    }
    
}

- (void)checkAlertMessage
{
    NSString *interfaceUrl = [NSString stringWithFormat:@"warn/list/%d.json", [[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY] intValue]];
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:interfaceUrl completionHandle:^(id returnObject) {
        NSLog(@"announcement data is : %@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
        NSDictionary *returnDict = [[NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil] categoryObjectForKey:@"resultInfo"];
        if ([[returnDict objectForKey:@"retCode"] intValue] == 3) {
            return ;
        }
        NSArray *list = [returnDict categoryObjectForKey:@"list"];
        for (id x in list) {
            AlertRecordModel *model = [[AlertRecordModel alloc] initWithDict:x];
            [[AlertRecordManager sharedManager] addOne:model];
        }
        
        [self refreshBadgeView];
        
    } failed:^{
        
    } hitSuperView:nil method:kGet];
    
    [self refreshBadgeView];
    
}
@end
