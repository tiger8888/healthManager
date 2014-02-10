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
    
    
//    NSMutableArray *testDataSource = [NSMutableArray new];
//    NSMutableDictionary *item = [NSMutableDictionary new];
//    for (int i=0; i<5; i++) {
//        [item setObject:@"这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什么这是什." forKey:@"msg"];
//        [item setObject:@"175" forKey:@"systolicPressure"];
//        [item setObject:@"120" forKey:@"diastolicPressure"];
//        [item setObject:@"85" forKey:@"pressId"];
//        [item setObject:@"2014-11-12 14:23" forKey:@"createTime"];
//        [testDataSource addObject:item];
//        
//        AlertRecordModel *alertRecordModel = [AlertRecordModel new];
//        alertRecordModel.highPressure = [item objectForKey:@"systolicPressure"];
//        alertRecordModel.lowPressure = [item objectForKey:@"diastolicPressure"];
//        alertRecordModel.pulse = [item objectForKey:@"pressId"];
//        alertRecordModel.receiveDateStr = [item objectForKey:@"createTime"];
//        alertRecordModel.bloodDateStr = [item objectForKey:@"createTime"];
//        alertRecordModel.content = [item objectForKey:@"msg"];
//        alertRecordModel.isRead = FALSE;
//        [[AlertRecordManager sharedManager] addOne:alertRecordModel];
//    }
//    _dataSource = testDataSource;
//    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentity = @"alertCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
//    }
//    
    NSDictionary *item = [_dataSource objectAtIndex:[indexPath row]];
//    cell.textLabel.text = [item objectForKey:@"msg"];
////    UILabel * detailTextLabel = [[UILabel alloc] init];
//    NSMutableString *text = [NSMutableString new];
//    [text appendString:[item objectForKey:@"createTime"]];
//    
//    [text appendString:@" 高压"];
//    [text appendString:[item objectForKey:@"systolicPressure"]];
//    [text appendString:@" 低压"];
//    [text appendString:[item objectForKey:@"diastolicPressure"]];
//    [text appendString:@" 脉搏"];
//    [text appendString:[item objectForKey:@"pressId"]];
//    cell.detailTextLabel.text = text;

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
    NSLog(@"heightfor=%f", height);
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
