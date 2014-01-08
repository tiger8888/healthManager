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

@interface KnowledgeViewController ()
{
    NSMutableArray *_knowledgeArr;
}
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[KnowledgeStore sharedStore] fetchTopInfo:10 withCompletion:^(NSMutableArray *obj, NSError *err) {
        _knowledgeArr = obj;
        [_tableView reloadData];
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
    
    Knowledge *knowledgeItem = [_knowledgeArr objectAtIndex:[indexPath row]];
    cell.textLabel.text = knowledgeItem.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_knowledgeArr count];
}
@end
