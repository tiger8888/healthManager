//
//  MedinceAddViewController.m
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "MedinceAddViewController.h"
#import "MedinceRecordManager.h"
#import "MedinceRecordModel.h"

@interface MedinceAddViewController ()
{
    UITableView *_tableView;
    NSArray *_dataSource;
    NSMutableArray *_dataSourceCheck;
}
@end

@implementation MedinceAddViewController

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
    [self reloadDataSource];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 160, DEVICE_WIDTH - 40, 238) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellRemindPeriod";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [_dataSource objectAtIndex:[indexPath row]];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 10, 14, 14)];
    btn.tag = [indexPath row];
    if ( [[_dataSourceCheck objectAtIndex:[indexPath row]] intValue] == 1 ) {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg_checked"] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(clickButtonCheck:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:btn];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - text delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.medicineName resignFirstResponder];
}

#pragma mark - 自定义方法
- (void)reloadDataSource {
    _dataSource = [NSArray new];
    _dataSource = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    _dataSourceCheck = [[NSMutableArray alloc] initWithObjects:@1,@1,@1,@1,@1,@1,@1, nil];
}
- (void)clickButtonCheck:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [_dataSourceCheck setObject:[NSNumber numberWithInt:[[_dataSourceCheck objectAtIndex:btn.tag] intValue] == 1?0:1]  atIndexedSubscript:btn.tag];
    if ( [[_dataSourceCheck objectAtIndex:btn.tag] intValue] == 1) {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg_checked"] forState:UIControlStateNormal];
    }
    else {
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
    }

}
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSubmit:(id)sender {
    if ([self.medicineName.text isEqualToString:@""]) {
        ALERT(@"", @"请输入药品名称。", @"确定");
        return;
    }
    MedinceRecordModel *medinceRecord = [MedinceRecordModel new];
    medinceRecord.name = self.medicineName.text;
    medinceRecord.uid = [[UserBusiness sharedManager] getCurrentPatientID];
    medinceRecord.createTime = [NSDate date];
    medinceRecord.period = [[_dataSourceCheck valueForKey:@"description"] componentsJoinedByString:@""];
    if ( [[MedinceRecordManager sharedManager] addOne:medinceRecord] ) {
        ALERT(@"", @"新增药品成功。", @"确定");
//        self.medicineName.text = @"";
//        [_tableView reloadData];
        if (self.block) {
            self.block();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
