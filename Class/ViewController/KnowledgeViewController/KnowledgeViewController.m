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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    cell.textLabel.text = [[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KnowledgeDetailViewController *detailViewCtl = [[KnowledgeDetailViewController alloc] initWithCategory:8];
    NSDictionary *item = [_dataSource objectAtIndex:[indexPath row]];
    Knowledge *knowledgeData = [[Knowledge alloc] initWithId:[[item objectForKey:@"id"] intValue] withTitle:[item categoryObjectForKey:@"title"] withContent:[item categoryObjectForKey:@"content"]];
    detailViewCtl.knowledgeModel = knowledgeData;
    knowledgeData = Nil;
//    Knowledge *knowledge = [_dataSource objectAtIndex:[indexPath row]];
//    detailViewCtl.url = knowledge.url;
    /**
     *  这里我感觉考虑到今后的拓展性传模型比较好，不管评论收藏还是分享都需要模型的其他属性
     
     **之前我也这么想的，但是因为完全后台维护，不保存本地，也没有其他功能个人感觉多此一举
     */
//    detailViewCtl.knowledgeModel = [_dataSource objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:detailViewCtl animated:YES];
}
@end
