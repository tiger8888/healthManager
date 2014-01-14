//
//  SettingRemindTimeViewController.m
//  HealthManager
//
//  Created by user on 14-1-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SettingRemindTimeViewController.h"

@interface SettingRemindTimeViewController ()
{
    NSMutableArray *_timeArr;
}
@end

@implementation SettingRemindTimeViewController
@synthesize selectedValue, dismissBlock;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _timeArr = [NSMutableArray new];
    [_timeArr addObject:[NSString stringWithFormat:@"%d", 1]];
    for (int i=5; i<61; i+=5) {
        [_timeArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_timeArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *currentValue = [_timeArr objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@分钟", currentValue];
    if ([self.selectedValue isEqualToString:currentValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currentValue = [_timeArr objectAtIndex:[indexPath row]];
    [[NSUserDefaults standardUserDefaults] setObject:currentValue forKey:@"settingRemindTime"];
    self.dismissBlock(currentValue);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
