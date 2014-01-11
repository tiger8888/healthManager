//
//  KnowledgeViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "KnowledgeStore.h"
#import "Knowledge.h"
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
    // Do any additional setup after loading the view from its nib.
    
//    _activityIndicatorLoading = [UIActivityIndicatorView new];
//    _activityIndicatorLoading.frame = CGRectMake(_backButtonItem.frame.size.width, (_navigationBar.frame.size.height-32)/2, 32, 32);
//    _activityIndicatorLoading.hidden = false;
//    [_activityIndicatorLoading startAnimating];
//    [_navigationBar addSubview:_activityIndicatorLoading];
    
//    [[KnowledgeStore sharedStore] fetchTopInfo:10 withCompletion:^(NSMutableArray *obj, NSError *err) {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[KnowledgeStore sharedStore] fetchTopwithCompletion:^(NSMutableArray *obj, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        _dataSource = obj;
        if (_dataSource)
        {
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"暂无信息" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
//        _activityIndicatorLoading.hidden = YES;
//        [_activityIndicatorLoading stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        imageView.frame = CGRectMake(280, 4, 35, 35);
        [cell addSubview:imageView];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
    }
    
    Knowledge *knowledgeItem = [_dataSource objectAtIndex:[indexPath row]];
    cell.textLabel.text = knowledgeItem.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KnowledgeDetailViewController *detailViewCtl = [[KnowledgeDetailViewController alloc] initWithCategory:8];
    Knowledge *knowledge = [_dataSource objectAtIndex:[indexPath row]];
    detailViewCtl.url = knowledge.url;
    [self.navigationController pushViewController:detailViewCtl animated:YES];
}
@end
