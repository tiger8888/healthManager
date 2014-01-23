//
//  SettingRemindTimeViewController.m
//  HealthManager
//
//  Created by PanPeng on 14-1-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SettingRemindTimeViewController.h"

@interface SettingRemindTimeViewController ()
{
    NSArray *_timeArr;
}
@end

@implementation SettingRemindTimeViewController
@synthesize selectedValue, dismissBlock;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _timeArr = [NSArray arrayWithObjects:@"15", @"30", @"60", @"120", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currentValue = [_timeArr objectAtIndex:[indexPath row]];
    [[NSUserDefaults standardUserDefaults] setObject:currentValue forKey:SETTING_REMIND_TIME_KEY];
    self.dismissBlock(currentValue);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
