//
//  SettingAndMoreSuperViewController.m
//  HealthManager
//
//  Created by LiShuo on 14-1-17.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SettingAndMoreSuperViewController.h"

@interface SettingAndMoreSuperViewController ()

@end

@implementation SettingAndMoreSuperViewController

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
	// Do any additional setup after loading the view.
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
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}
@end
