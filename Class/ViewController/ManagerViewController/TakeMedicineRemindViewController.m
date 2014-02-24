//
//  TakeMedicineRemindViewController.m
//  HealthManager
//
//  Created by user on 14-2-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "TakeMedicineRemindViewController.h"
#import "MedinceAddViewController.h"
#import "SetUsingMedinceTimeViewController.h"
#import "MedinceRecordManager.h"
#import "SetUsingMedinceTimeViewController.h"

@interface TakeMedicineRemindViewController ()

@end

@implementation TakeMedicineRemindViewController

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
    [self addAddButtonOnNavigation];
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写父类方法
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:FULLSCREEN style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ( indexPath.row == 0) {
        cell = [self buildTitleCell:tableView indexPath:indexPath];
    }
    else {
        cell = [self buildTimeCell:tableView indexPath:indexPath];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - 自定义方法
- (void)addAddButtonOnNavigation {
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(DEVICE_WIDTH - 54, 0, 44, 44);
    [addBtn setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addMedince:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:addBtn];
}

- (void)addMedince:(id)sender {
    MedinceAddViewController *medinceAddCtl = [[MedinceAddViewController alloc] initWithCategory:21];
    [self presentViewController:medinceAddCtl animated:YES completion:nil];
}

- (void)loadDataSource {
    _dataSource = [NSArray new];
    _dataSource = [[MedinceRecordManager sharedManager] fetchAll:[[UserBusiness sharedManager] getCurrentPatientID]];
//    [_tableView reloadData];
//    for (NSManagedObject *item in _dataSource) {
//        NSLog(@"obj name is %@", [item valueForKey:@"name"]);
//    }

}

- (UITableViewCell *)buildTitleCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *cellTitleIdentity = @"remindCellTitle";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTitleIdentity];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellTitleIdentity];
    }
    NSManagedObject *obj = (NSManagedObject *)[_dataSource objectAtIndex:[indexPath section]];
    NSString *name = [obj valueForKey:@"name"];
    [self formatUsingMedincePeriod:[obj valueForKey:@"period"]];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [self formatUsingMedincePeriod:[obj valueForKey:@"period"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 60, 6, 28, 28)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_remind_time"] forState:UIControlStateNormal];
    btn.tag = indexPath.section;
    [btn addTarget:self action:@selector(addRemindTime:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    return cell;
}
- (UITableViewCell *)buildTimeCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *cellTimeIdentity = @"remindCellTime";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTimeIdentity];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTimeIdentity];
    }
    cell.textLabel.text = @"ads";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 60, 6, 28, 28)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_edit_time"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addRemindTime:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    return cell;
}

- (void)addRemindTime:(id)sender {
    NSLog(@"aaa");
    SetUsingMedinceTimeViewController *setTimeCtl = [[SetUsingMedinceTimeViewController alloc] initWithCategory:22];
    setTimeCtl.medince = [_dataSource objectAtIndex:[(UIButton *)sender tag]];
    [self presentViewController:setTimeCtl animated:YES completion:nil];
}

- (NSString *)formatUsingMedincePeriod:(NSString *)period {
    if (period.length!=7) {
        return @"";
    }
    if ([period isEqualToString:@"1111111"]) {
        return @"每日";
    }
    NSMutableString *resultStr = [NSMutableString stringWithString:@""];
    for (int i = 0; i<period.length; i++) {
        if ([period characterAtIndex:i] == '1') {
            [resultStr appendString:[self numberToWeekName:i]];
            [resultStr appendString:@" "];
        }
    }
    
     return  resultStr;
}

- (NSString *)numberToWeekName:(int)num {
    NSString *weekName = @"";
    switch (num) {
        case 0:
            weekName = @"周一";
            break;
        case 1:
            weekName = @"周二";
            break;
        case 2:
            weekName = @"周三";
            break;
        case 3:
            weekName = @"周四";
            break;
        case 4:
            weekName = @"周五";
            break;
        case 5:
            weekName = @"周六";
            break;
        case 6:
            weekName = @"周日";
            break;
        default:
            break;
    }
    
    return weekName;
}
@end
