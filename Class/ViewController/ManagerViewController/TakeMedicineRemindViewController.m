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
    NSMutableDictionary *_deleteObject;
    NSDate *_updateDate;

    int _recorderPage;
    int _recorderLimit;
    BOOL _recorderFetchAll;
}
@end

@implementation TakeMedicineRemindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _recorderPage = 1;
    _recorderLimit = 10;
    _recorderFetchAll = NO;
    
    if ( _refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height) arrowImageName:@"pull_refresh_downArrow" textColor:[UIColor grayColor]];
        view.delegate = self;
        [_tableView addSubview:view];
        _refreshHeaderView = view;
        view = nil;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self addAddButtonOnNavigation];
    [self loadDataSource];
}

- (void)viewDidUnload
{
    _refreshHeaderView = nil;
}
- (void)dealloc
{
    _refreshHeaderView = nil;
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
    if (indexPath.section>=_dataSource.count) {
        cell = [self buildMoreCell:tableView indexPath:indexPath];
    }
    else {
        if ( indexPath.row == 0) {
            cell = [self buildTitleCell:tableView indexPath:indexPath];
        }
        else {
            cell = [self buildTimeCell:tableView indexPath:indexPath];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataSource.count>0) {
        if (_recorderFetchAll) {
            return _dataSource.count;
        }
        else {
            return _dataSource.count+1;
        }
    }
    else {
        return 0;
    }
//    return  _dataSource.count>0?(_dataSource.count+1):0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section>=_dataSource.count) {
        return 1;
    }
    
    NSString *key = [self getRemindTimeKey:section];
    if ( ![_timeDataSource objectForKey:key] ) {
//        NSLog(@"as");
        [_timeDataSource setObject:[[MedinceRemindTimeManager sharedManager] fetchAll:[[_dataSource objectAtIndex:section] valueForKey:@"id"]] forKey:key];
    }
    else {
//        NSLog(@"ddd");
        
    }
    return [[_timeDataSource objectForKey:key] count] + 1;
//    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==_dataSource.count) {
        return;
    }
    else {
        NSManagedObject *obj = (NSManagedObject *)[_dataSource objectAtIndex:[indexPath section]];
        [self goToAddMedince:obj];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>=_dataSource.count) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row == 0) {
//            NSLog(@"delete medince");
            [self readyForDeleteMedinceRecord:indexPath];
        }
        else if (indexPath.row > 0) {
//            NSLog(@"delete time");
            [self readyForDeleteMedinceRemindTimeRecord:indexPath];
        }
    }
}

#pragma mark - AlertDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 901:
        {
            if (buttonIndex == 0) {
                return;
            }
            else if (buttonIndex == 1)
            {
                [self deleteMedinceRecord];
            }
        }
            break;
        case 902:
        {
            if (buttonIndex == 0) {
                return;
            }
            else if (buttonIndex == 1)
            {
                [self deleteMedinceRemindTimeRecord];
            }

        }
            break;
        default:
            break;
    }
}

#pragma mark - 自定义方法
- (void)addAddButtonOnNavigation {
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(DEVICE_WIDTH - 54, 0, 44, 44);
    [addBtn setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addMedince:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:addBtn];
}

- (void)readyForDeleteMedinceRecord:(NSIndexPath *)indexPath {
    NSManagedObject *obj = (NSManagedObject *)[_dataSource objectAtIndex:[indexPath section]];
    NSString *name = [obj valueForKey:@"name"];
    if (name == NULL) name = @"";
    _deleteObject = [NSMutableDictionary new];
    [_deleteObject setObject:obj forKey:@"obj"];
    [_deleteObject setObject:indexPath forKey:@"index"];
    NSString *alertMessage = [NSString stringWithFormat:@"删除药品【%@】及其提醒？", name];
    ALERTOPRATE(@"", alertMessage, 901);
}

- (void)readyForDeleteMedinceRemindTimeRecord:(NSIndexPath *)indexPath {
    NSManagedObject *obj = (NSManagedObject *)[_dataSource objectAtIndex:[indexPath section]];
    NSString *name = [obj valueForKey:@"name"];
    if (name == NULL) name = @"";
    
    NSArray *remindTimeArray = [_timeDataSource objectForKey:[self getRemindTimeKey:indexPath.section]];
    NSManagedObject *detailObj = [remindTimeArray objectAtIndex:(indexPath.row-1)];
    NSString *time = [detailObj  valueForKey:@"remindTime"];
    
    NSString *alertMessage = [NSString stringWithFormat:@"删除药品【%@】在【%@】时的提醒？", name, time];
    
    _deleteObject = [NSMutableDictionary new];
    [_deleteObject setObject:detailObj forKey:@"obj"];
    [_deleteObject setObject:indexPath forKey:@"index"];
    ALERTOPRATE(@"", alertMessage, 902);
}

- (void)deleteMedinceRecord {
    if (_deleteObject) {
        NSDictionary *obj = [_deleteObject copy];
        _deleteObject = nil;
        [[MedinceRecordManager sharedManager] deleteOne:[obj objectForKey:@"obj"]];
        [self reloadDataSourceAndRefresh];
    }
}

- (void)deleteMedinceRemindTimeRecord {
    if (_deleteObject) {
        NSDictionary *obj = [_deleteObject copy];
        _deleteObject = nil;
        [[MedinceRemindTimeManager sharedManager] deleteOne:[obj objectForKey:@"obj"]];
        [self reloadDataSourceAndRefresh];
    }
}

- (void)addMedince:(id)sender {
    [self goToAddMedince:nil];
}
- (void)goToAddMedince:(NSManagedObject *)obj {
    MedinceAddViewController *medinceAddCtl = [[MedinceAddViewController alloc] initWithCategory:21];
    medinceAddCtl.medince = obj;
    [medinceAddCtl setBlock:^(void){
        [self reloadDataSourceAndRefresh];
    }];
    [self.navigationController pushViewController:medinceAddCtl animated:YES];
}

- (void)loadDataSource {
    _dataSource = [NSArray new];
    _dataSource = [[MedinceRecordManager sharedManager] fetchAll:[[UserBusiness sharedManager] getCurrentPatientID] page:_recorderPage num:_recorderLimit];
    if (_dataSource.count<=0) {
        _recorderFetchAll = YES;
//        _recorderPage--;
    }
    _timeDataSource = [NSMutableDictionary new];
    _updateDate = [NSDate date];
//    NSLog(@"data source count is :%d",_dataSource.count);
}

- (void)reloadDataSourceAndRefresh {
    [self loadDataSource];
    [_tableView reloadData];
}

- (UITableViewCell *)buildMoreCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //////
    [self performSelectorInBackground:@selector(fetchNextPageData:) withObject:nil];
    //////
    static NSString *cellTitleIdentity = @"remindCellMore";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTitleIdentity];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTitleIdentity];
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((DEVICE_WIDTH - 120)/2, 8, 120, 28)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg_gray"] forState:UIControlStateNormal];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fetchNextPageData:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    return cell;
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
    [btn addTarget:self action:@selector(updateRemindTime:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = indexPath.section*1000 +indexPath.row;
    [cell addSubview:btn];
    return cell;
}

- (void)addRemindTime:(id)sender {
    SetUsingMedinceTimeViewController *setTimeCtl = [[SetUsingMedinceTimeViewController alloc] initWithCategory:22];
    setTimeCtl.medince = [_dataSource objectAtIndex:[(UIButton *)sender tag]];
    [setTimeCtl setBlock:^(void){
        [self reloadDataSourceAndRefresh];
    }];
    [self.navigationController pushViewController:setTimeCtl animated:YES];
}

- (void)updateRemindTime:(id)sender {
    UIButton *btn= (UIButton *)sender;
    int row = btn.tag % 1000;
    int section = (int)floorf(btn.tag/1000);
    
    SetUsingMedinceTimeViewController *setTimeCtl = [[SetUsingMedinceTimeViewController alloc] initWithCategory:22];
    setTimeCtl.medince = [_dataSource objectAtIndex:section];
    [setTimeCtl setBlock:^(void){
        [self reloadDataSourceAndRefresh];
    }];
    
    
//    NSLog(@"section=%d,row=%d",section, row);
    NSArray *remindTimeArray = [_timeDataSource objectForKey:[self getRemindTimeKey:section]];
    setTimeCtl.remindTime = [remindTimeArray objectAtIndex:(row-1)];
    [self.navigationController pushViewController:setTimeCtl animated:YES];
}

- (void)fetchNextPageData:(id)sender {
//    NSLog(@"page=%d",_recorderPage);
    _recorderPage++;
    
    NSArray *nextPageData = [[MedinceRecordManager sharedManager] fetchAll:[[UserBusiness sharedManager] getCurrentPatientID] page:_recorderPage num:_recorderLimit];
    if (nextPageData.count>0) {
//        _recorderPage++;
        
        NSMutableArray *tmpData = [NSMutableArray arrayWithArray:_dataSource];
        for (NSManagedObject *item in nextPageData) {
            [tmpData addObject:item];
        }
        _dataSource = tmpData;    
    }
    else {
        _recorderFetchAll = YES;
        _recorderPage--;
    }
    [_tableView reloadData];
    _updateDate = [NSDate date];
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

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
//	return [NSDate date]; // should return date data source was last changed
    return _updateDate?_updateDate:[NSDate date];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    _recorderPage = 1;
    _recorderFetchAll = NO;
	[self reloadDataSourceAndRefresh];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
@end
