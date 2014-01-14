//
//  MoreViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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
    [self layoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Method
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:FULLSCREEN style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)layoutView
{
    [super layoutView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 380, 269, 44);
    [button setImage:[UIImage imageNamed:@"bt_logoff"] forState:UIControlStateNormal];
    [self.view addSubview:button];
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
    }
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"公告";
        }
        else if (indexPath.row == 1)
//        {
//            cell.textLabel.text = @"关注微信公告账号";
//        }
//        else if (indexPath.row == 2)
//        {
//            cell.textLabel.text = @"关于301";
//        }
//        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"意见反馈";
        }
//        [cell addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]];
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"修改密码";
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
//            return 4;
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSLog(@"公告");
        }
        else if (indexPath.row == 1)
//        {
//            NSLog(@"关注微信公告账号");
//        }
//        else if (indexPath.row == 2)
//        {
//            NSLog(@"关于301");
//        }
//        else if (indexPath.row == 3)
        {
            NSLog(@"意见反馈");
        }
    }
    else if (indexPath.section == 1)
    {
        NSLog(@"修改密码");
    }
}
@end
