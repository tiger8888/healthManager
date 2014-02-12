//
//  SettingViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingRemindTimeViewController.h"
#import "DoctorBusiness.h"

@interface SettingViewController ()
{
    NSString *_settingRemindTime;
    float _cacheTotal;
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

//#pragma mark - Layout Method
//- (void)createTableView
//{
//    _tableView = [[UITableView alloc] initWithFrame:FULLSCREEN style:UITableViewStyleGrouped];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [self.view addSubview:_tableView];
//}
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
            UISwitch *soundSwitch = [UISwitch new];
            int switchRightGap;
            if (IS_IOS7) {
                switchRightGap = 60;
            }
            else {
                switchRightGap = 100;
            }
            soundSwitch.frame = CGRectMake(cell.bounds.size.width - switchRightGap, (cell.bounds.size.height - soundSwitch.frame.size.height) /2, 0.0,  0.0);
            [soundSwitch addTarget:self action:@selector(switchSoundChanged:) forControlEvents:UIControlEventValueChanged];
//            if ( [[NSUserDefaults standardUserDefaults] objectForKey:SETTING_REMIND_SOUND_KEY] ) {
                soundSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTING_REMIND_SOUND_KEY] boolValue];
            [cell addSubview:soundSwitch];
            cell.selected = NO;
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
        cell.detailTextLabel.text = [NSString stringWithFormat:@"缓存大小：%@", [self getCacheSize]];
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

//-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return nil;
//    }
//    else {
//        return indexPath;
//    }
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
            SettingRemindTimeViewController *settingRemindTimeViewCtl = [[SettingRemindTimeViewController alloc] initWithCategory:10];
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
        if (_cacheTotal>0)
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: message: delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alert.tag = ;
//            [alert show];
            ALERTOPRATE(@"警告", @"您将清除所有缓存内容", 2);
        }
    }
    else
    {
        NSLog(@"重新选择“我的医生”");
        /**
         * 目前缺少的操作：提醒用户：将清除用户与医生的关系，让用户进行确认
         */
        NSString *doctorID = [self getCurrentDoctorID];
        if (doctorID == nil || [doctorID intValue] == 0)
        {
            ALERTOPRATE(@"警告", @"您尚未选取任何医生，请先进入我的医生界面选择您的私人医生", 3);
        }
        else
        {
            ALERTOPRATE(@"警告", @"您将重新选择医生", 3);
        }
    }
}

#pragma mark - AlertDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 2:
        {
            if (buttonIndex == 0) {
                return;
            }
            else if (buttonIndex == 1)
            {
                NSLog(@"开始删除缓存");
                [self cleanCache];
                [_tableView reloadData];
            }
        }
            break;
        case 3:
        {
            if (buttonIndex == 0) {
                return;
            }
            else if (buttonIndex == 1)
            {
                [self irrelate];
                DoctorViewController *myDoctorViewCtl = [[DoctorViewController alloc] initWithCategory:2];
                [self.navigationController pushViewController:myDoctorViewCtl animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)switchSoundChanged:(id)sender {
    UISwitch *switchCtl = (UISwitch *)sender;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:switchCtl.on] forKey:SETTING_REMIND_SOUND_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCacheSize {
    NSString *fileTotalSize;
    float total = 0.0f;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSLog(@"cache directory path is : %@", cachePath);
    
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:cachePath];

    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [[cachePath stringByAppendingString:@"/" ] stringByAppendingString: fileName];
        NSDictionary *fileArrts = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];

        if (fileArrts) {
            NSNumber *fileSize = [fileArrts objectForKey:NSFileSize];
//            NSLog(@"file name \"%@\" size is : %@",fileName,fileSize);
            total += [fileSize floatValue];
        }
    }
    if (total > 1024) {
        //单位Kb
        total = total/(1024);
        
        if (total > 1024) {
            //单位Mb
            total = total/(1024);
            
            if (total > 1024) {
                //单位Gb
                total = total/(1024);
                fileTotalSize = [NSString stringWithFormat:@"%.2f GB",total];
            }
            else {
                fileTotalSize = [NSString stringWithFormat:@"%.2f MB",total];
            }
        }
        else {
            fileTotalSize = [NSString stringWithFormat:@"%.2f KB",total];
        }
    }
    else {
        fileTotalSize = [NSString stringWithFormat:@"%.0f B",total];
    }
    _cacheTotal = total;
//    NSLog(@"total file size is %@",fileTotalSize);
    return fileTotalSize;
}

/**
 *还可以增加效果：时时的反馈给用户清除缓存的进度
 */
- (void)cleanCache {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:cachePath];
    
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [[cachePath stringByAppendingString:@"/" ] stringByAppendingString: fileName];
        if ([[NSFileManager defaultManager]removeItemAtPath:filePath error:nil]) {
            NSLog(@"success");
        }
        else {
            NSLog(@"failed delete %@", filePath);
        }
    }
}
//取消绑定医生
- (void)irrelate
{
    [[DoctorBusiness sharedManager] deleteMyDoctor];
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    
//    NSString *url = [NSString stringWithFormat:@"patient/doctor/delete/%@/%@.json",[self getCurrentPatientID],[self getCurrentDoctorID]];
//    NSLog(@"%@",url);
//    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:url  completionHandle:^(id returnObject) {
//        
//        NSLog(@"%@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
//            
//        } failed:^{
//            
//        } hitSuperView:nil method:kPost];
//    
//    [userDef removeObjectForKey:DOCTORID_KEY];
//    [userDef synchronize];
}
@end


