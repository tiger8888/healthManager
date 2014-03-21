//
//  KnowledgeViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "KnowledgeDetailViewController.h"

@interface KnowledgeViewController ()
//{
//    NSMutableArray *_knowledgeArr;
//}
@end

@implementation KnowledgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:@"health.json" completionHandle:^(id returnObject) {
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


#pragma mark - TableView Delegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentity = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
//        imageView.frame = CGRectMake(280, 4, 35, 35);
//        [cell addSubview:imageView];
//        cell.textLabel.font = [UIFont systemFontOfSize:20];
//    }
//    
//    Knowledge *knowledgeItem = [_dataSource objectAtIndex:[indexPath row]];
//    cell.textLabel.text = knowledgeItem.title;
//    
//    return cell;

    static NSString *cellIdentity = @"knowledgeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    
    static NSDateFormatter *dateFormater;
    static NSDateFormatter *dateFormaterFromString;
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy.MM.dd HH:mm";
        
        dateFormaterFromString = [[NSDateFormatter alloc] init];
        dateFormaterFromString.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSString *createTimeStr;
    createTimeStr = [[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"createTime"];
    NSDate *createTime = [dateFormaterFromString dateFromString:createTimeStr];

    cell.textLabel.text = [[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"title"];
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
    KnowledgeDetailViewController *detailViewCtl = [[KnowledgeDetailViewController alloc] initWithCategory:8];
    NSDictionary *item = [_dataSource objectAtIndex:[indexPath row]];
    Knowledge *knowledgeData = [[Knowledge alloc] initWithId:[[item objectForKey:@"id"] intValue] withTitle:[item categoryObjectForKey:@"title"] withTime:[item categoryObjectForKey:@"createTime"]  withContent:[item categoryObjectForKey:@"content"]];
    detailViewCtl.knowledgeModel = knowledgeData;
    knowledgeData = Nil;
    
    [self.navigationController pushViewController:detailViewCtl animated:YES];
}
@end
