//
//  AlertViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "AlertViewController.h"
#import "AlertCustomCell.h"
#import "AlertRecordManager.h"
#import "AlertRecordModel.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _algorithm = [Algorithm new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSString *interfaceUrl = [NSString stringWithFormat:@"warn/list/%d.json", [[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY] intValue]];
//    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:interfaceUrl completionHandle:^(id returnObject) {
//        //        NSLog(@"announcement data is : %@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
//        NSDictionary *announcementDataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
//        _dataSource = [[announcementDataDictionary objectForKey:@"resultInfo"] objectForKey:@"list"];
//        [_tableView reloadData];
//    } failed:^{
//        
//    } hitSuperView:_tableView method:kGet];
    

    NSArray *alertRecordList = [[AlertRecordManager sharedManager] fetchAll];
//    NSLog(@"alert record count is : %d", [alertRecordList count]);
    for (NSDictionary *item in alertRecordList) {
//        NSLog(@"item is : %@",[item valueForKey:@"content"]);
        
    }
    _dataSource = alertRecordList;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [_dataSource objectAtIndex:[indexPath row]];

    AlertCustomCell *cell = [self customCellByCode:tableView withIndexPath:indexPath];
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    [cell setupCell:item withHeight:height];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [_algorithm calculation:indexPath data:_dataSource];
//    NSLog(@"heightfor=%f", height);
    return height;
}

- (AlertCustomCell *)customCellByCode:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    static NSString *customCellIdentifierWithCode = @"CustomCellIdentifierWithCode";
    AlertCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifierWithCode];
    if (cell == nil) {
        cell = [[AlertCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellIdentifierWithCode];
    }
    
    return cell;
}
@end
