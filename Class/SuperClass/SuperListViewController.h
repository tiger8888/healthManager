//
//  SuperListViewController.h
//  HealthManager
//
//  Created by 李硕 on 13-12-18.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "RootSuperViewController.h"

@interface SuperListViewController : BackButtonViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataSource;
}

@end
