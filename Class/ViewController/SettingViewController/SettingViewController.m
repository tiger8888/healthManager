//
//  SettingViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingRemindTimeViewController.h"

@interface SettingViewController ()
{
    NSString *_settingRemindTime;
}
@end

@implementation SettingViewController

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
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:FULLSCREEN style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
#pragma mark - TableView Delegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"服药声音提醒";
            
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity];
            cell.textLabel.text = @"提前提醒时间";
            _settingRemindTime = [[NSUserDefaults standardUserDefaults] objectForKey:SETTING_REMIND_TIME_KEY];
            if (!_settingRemindTime) {
                _settingRemindTime = @"15";
                [[NSUserDefaults standardUserDefaults] setObject:_settingRemindTime forKey:SETTING_REMIND_TIME_KEY];
            }
            cell.detailTextLabel.text =  [_settingRemindTime stringByAppendingString:@"分钟"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section == 1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity];
        cell.textLabel.text = @"清除缓存";
        cell.detailTextLabel.text = @"缓存大小：3M";
    }
    else
    {
        cell.textLabel.text = @"重新选择“我的医生”";
    }
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 45;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSLog(@"服药声音提醒");
        }
        else
        {
            NSLog(@"提前提醒时间");
            SettingRemindTimeViewController *settingRemindTimeViewCtl = [SettingRemindTimeViewController new];
            settingRemindTimeViewCtl.selectedValue = _settingRemindTime;
            settingRemindTimeViewCtl.dismissBlock = ^(NSString *time){
                _settingRemindTime = time;
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:settingRemindTimeViewCtl animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        NSLog(@"清除缓存");
    }
    else
    {
        NSLog(@"重新选择“我的医生”");
        /**
         * 目前缺少的操作：提醒用户：将清除用户与医生的关系，让用户进行确认
         */
        NSNumber *doctorID = [[NSUserDefaults standardUserDefaults] objectForKey:@"myDoctorID"];
        if (doctorID == nil || [doctorID intValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您尚未选取任何医生，请先进入我的医生界面选择您的私人医生" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 3;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您将重新选择医生" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 3;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 3:
        {
            if (buttonIndex == 0) {
                return;
            }
            else if (buttonIndex == 1)
            {
                NSLog(@"中心薛泽");
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myDoctorID"];
                DoctorViewController *myDoctorViewCtl = [[DoctorViewController alloc] initWithCategory:2];
                [self.navigationController pushViewController:myDoctorViewCtl animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

@end


