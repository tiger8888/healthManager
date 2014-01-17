//
//  AnnouncementViewController.m
//  DrugHousekeeper
//
//  Created by user on 14-1-17.
//  Copyright (c) 2014年 user. All rights reserved.
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
        NSLog(@"%@",_dataSource);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    cell.textLabel.text = [[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"title"];
//    cell.detailTextLabel.text = @"a";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementDetailViewController *detailCtl = [[AnnouncementDetailViewController alloc] initWithCategory:12];
    
    NSDictionary *item = [_dataSource objectAtIndex:[indexPath row]];
    Announcement *announcementData = [[Announcement alloc] initWithId:[[item objectForKey:@"id"] intValue] withTitle:[item categoryObjectForKey:@"title"] withContent:[item categoryObjectForKey:@"content"]];
    detailCtl.announcement = announcementData;
    announcementData = Nil;
    [self.navigationController pushViewController:detailCtl animated:YES];
}

@end
