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
#import "MedinceRemindTimeManager.h"
#import "SetUsingMedinceTimeViewController.h"

@interface TakeMedicineRemindViewController ()
{
    NSMutableDictionary *_timeDataSource;
}
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
    NSString *key = [self getRemindTimeKey:section];
    NSLog(@"key=%@", key);
    if ( ![_timeDataSource objectForKey:key] ) {
        NSLog(@"as");
        
        [_timeDataSource setObject:[[MedinceRemindTimeManager sharedManager] fetchAll:[[_dataSource objectAtIndex:section] valueForKey:@"id"]] forKey:key];
    }
    else {
        NSLog(@"ddd");
        
    }
    return [[_timeDataSource objectForKey:key] count] + 1;
//    return 3;
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
    [medinceAddCtl setBlock:^(void){
        [self loadDataSource];
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:medinceAddCtl animated:YES];
}

- (void)loadDataSource {
    _dataSource = [NSArray new];
    _dataSource = [[MedinceRecordManager sharedManager] fetchAll:[[UserBusiness sharedManager] getCurrentPatientID]];
    _timeDataSource = [NSMutableDictionary new];
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
    
    NSArray *remindTimeArray = [_timeDataSource objectForKey:[self getRemindTimeKey:indexPath.section]];
    cell.textLabel.text = [[remindTimeArray objectAtIndex:(indexPath.row-1)]  valueForKey:@"remindTime"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 60, 6, 28, 28)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_edit_time"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addRemindTime:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    return cell;
}

- (void)addRemindTime:(id)sender {
    SetUsingMedinceTimeViewController *setTimeCtl = [[SetUsingMedinceTimeViewController alloc] initWithCategory:22];
    setTimeCtl.medince = [_dataSource objectAtIndex:[(UIButton *)sender tag]];
    [setTimeCtl setBlock:^(void){
        [self loadDataSource];
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:setTimeCtl animated:YES];
}

- (NSString *)getRemindTimeKey:(NSInteger)section {
    NSString *key = [NSString stringWithFormat:@"detail_%d", section];
    return key;
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
