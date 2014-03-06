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
    _tableView.scrollEnabled = NO;
    
    [self.view addSubview:_tableView];
    if (IS_IOS7) {
        self.medicineNameLabel.frame = CGRectMake(20, 44+20, DEVICE_WIDTH, 20);
        self.medicineName.frame = CGRectMake(20, 74+20, DEVICE_WIDTH - 20*2, 20);
        self.periodLabel.frame = CGRectMake(20, 104+20, DEVICE_WIDTH, 20);
        self.btnCancel.frame = CGRectMake(DEVICE_WIDTH - 20 - 120, DEVICE_HEIGHT-44-44, 120, 30);
        self.btnSubmit.frame = CGRectMake(20, DEVICE_HEIGHT-44-44, 120, 30);
    }
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
    
    PPCheckBox *btn = [[PPCheckBox alloc] initWithDelegate:self normalImage:[UIImage imageNamed:@"btn_bg_unchecked"] selectedImage:[UIImage imageNamed:@"btn_bg_checked_border"]];
    [btn setTitle:[_dataSource objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
    if ( [[_dataSourceCheck objectAtIndex:[indexPath row]] intValue] == 1 ) {
        [btn setChecked:YES];
    }
    btn.frame = CGRectMake(10, 10, 100, 14);
    btn.tag = [indexPath row];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [cell addSubview:btn];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark - PPCheckBox delegate
- (void)didSelectedCheckBox:(PPCheckBox *)checkbox checked:(BOOL)checked {
    [_dataSourceCheck setObject:[NSNumber numberWithInt:checked]  atIndexedSubscript:checkbox.tag];
}
#pragma mark - 自定义方法
- (void)reloadDataSource {
    _dataSource = [NSArray new];
    _dataSource = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    _dataSourceCheck = [[NSMutableArray alloc] initWithObjects:@1,@1,@1,@1,@1,@1,@1, nil];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSubmit:(id)sender {
    if (self.medicineName.text == NULL || [self.medicineName.text isEqualToString:@""]) {
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
        if (self.block) {
            self.block();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
