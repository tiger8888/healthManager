//
//  AnnouncementViewController.m
//  DrugHousekeeper
//
//  Created by PanPeng on 14-1-17.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "AnnouncementDetailViewController.h"
#import "Announcement.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

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
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:@"notice.json" completionHandle:^(id returnObject) {
//        NSLog(@"announcement data is : %@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
        NSDictionary *announcementDataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        _dataSource = [[announcementDataDictionary objectForKey:@"resultInfo"] objectForKey:@"list"];
        [_tableView reloadData];
    } failed:^{
        
    } hitSuperView:_tableView method:kGet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [_dataSource count];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"announcementCell";
    static NSDateFormatter *dateFormater;
    static NSDateFormatter *dateFormaterFromString;
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy.MM.dd HH:mm";
        
        dateFormaterFromString = [[NSDateFormatter alloc] init];
        dateFormaterFromString.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    cell.textLabel.text = [[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"title"];
    UIColor *detailTextColor = [UIColor colorWithRed:98.0f/255.0f green:98.0f/255.0f blue:98.0f/255.0f alpha:1.0f];
    cell.detailTextLabel.textColor = detailTextColor;
    
    NSString *createTimeStr;
    createTimeStr = [[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"createTime"];
//    NSLog(@"time string : %@",createTimeStr);
    NSDate *createTime = [dateFormaterFromString dateFromString:createTimeStr];
//    NSLog(@"time : %@",createTime);
    
    cell.detailTextLabel.text = [dateFormater stringFromDate:createTime];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementDetailViewController *detailCtl = [[AnnouncementDetailViewController alloc] initWithCategory:12];
    
    NSDictionary *item = [_dataSource objectAtIndex:[indexPath row]];
    Announcement *announcementData = [[Announcement alloc] initWithId:[[item objectForKey:@"id"] intValue] withTitle:[item categoryObjectForKey:@"title"] withTime:[item categoryObjectForKey:@"createTime"]  withContent:[item categoryObjectForKey:@"content"]];
    detailCtl.announcement = announcementData;
    announcementData = Nil;
    [self.navigationController pushViewController:detailCtl animated:YES];
}

@end
