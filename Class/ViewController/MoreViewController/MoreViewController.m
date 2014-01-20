//
//  MoreViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "MoreViewController.h"
#import "AnnouncementViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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

#pragma mark - Layout Method
- (void)layoutView
{
    [super layoutView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 380, 269, 44);
    [button setImage:[UIImage imageNamed:@"bt_logoff"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(logOff) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - TableView Delegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        imageView.frame = CGRectMake(280, 4, 35, 35);
        [cell addSubview:imageView];
    }
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"公告";
        }
        else if (indexPath.row == 1)
//        {
//            cell.textLabel.text = @"关注微信公告账号";
//        }
//        else if (indexPath.row == 2)
//        {
//            cell.textLabel.text = @"关于301";
//        }
//        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"意见反馈";
        }
//        [cell addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]];
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"修改密码";
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
//            return 4;
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSLog(@"公告");
            AnnouncementViewController *announcementViewCtl = [[AnnouncementViewController alloc] initWithCategory:11];
            [self.navigationController pushViewController:announcementViewCtl animated:YES];
            
        }
        else if (indexPath.row == 1)
//        {
//            NSLog(@"关注微信公告账号");
//        }
//        else if (indexPath.row == 2)
//        {
//            NSLog(@"关于301");
//        }
//        else if (indexPath.row == 3)
        {
            NSLog(@"意见反馈");
        }
    }
    else if (indexPath.section == 1)
    {
        NSLog(@"修改密码");
    }
}

#pragma mark - AlertDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 3:
        {
            if (buttonIndex == 0)
            {
                return;
            }
            else if (buttonIndex == 1)
            {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                [userDef removeObjectForKey:PATIENTID_KEY];
                [userDef removeObjectForKey:DOCTORID_KEY];
                [userDef synchronize];
                
                LoginViewController *loginViewController = [[LoginViewController alloc] init];
                ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = loginViewController;
            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - Event method
- (void)logOff
{
    ALERTOPRATE(@"警告", @"即将注销，注销后取消关联医生，返回登陆界面", 3);
}
@end
