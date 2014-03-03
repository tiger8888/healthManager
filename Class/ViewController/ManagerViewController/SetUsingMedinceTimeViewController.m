//
//  SetUsingMedinceTimeViewController.m
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SetUsingMedinceTimeViewController.h"
#import "MedinceRemindTimeManager.h"
#import "LocationNotificationBusiness.h"


@interface SetUsingMedinceTimeViewController ()
{
    MedinceRemindTimeModel *_remindTimeModel;
    UIPickerView *_tpicker;
    NSMutableArray *_hourArr;
    NSMutableArray *_minArr;
}
@end

@implementation SetUsingMedinceTimeViewController

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
//    self.timePicker.hidden = YES;
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    self.timePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    self.timePicker.backgroundColor = UICOLORFROMRGB(0xffffff);
    
    
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    dateFormatter.dateFormat = @"HH:mm";
//    self.timePicker setDate:<#(NSDate *)#>
    [self.timePicker addTarget:self action:@selector(timeChange:) forControlEvents:UIControlEventValueChanged];
    
    self.name.text = [self.medince valueForKey:@"name"];
//    NSLog(@"timepicker locale is %@",self.timePicker.locale.localeIdentifier);
//    NSLog(@"id=%@", self.medince.objectID);
    
    _remindTimeModel = [MedinceRemindTimeModel new];
    _remindTimeModel.id = [self.medince valueForKey:@"id"];
    _remindTimeModel.uid = [self.medince valueForKey:@"uid"];
    
    [self changePickerTime];
    
//    [self buildHourData];
//    [self buildMinuteData];
//    
//    _tpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, DEVICE_WIDTH, 100)];
//    _tpicker.backgroundColor = [UIColor redColor];
//    _tpicker.dataSource = self;
//    _tpicker.delegate = self;
//    
//    [self.view addSubview:_tpicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickDelete:(id)sender {
    if (self.remindTime) {
        if ([[MedinceRemindTimeManager sharedManager] deleteOne:self.remindTime]) {
            ALERT(@"", @"删除提醒成功。", @"确定");
            MedinceRemindTimeModel *remindTimeObj = (MedinceRemindTimeModel *)self.remindTime;
            MedinceRecordModel *recordObj = (MedinceRecordModel *)self.medince;
            [[LocationNotificationBusiness sharedManager] remove:remindTimeObj withPeriod:recordObj.period];
        }
        if (self.block) {
            self.block();
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSubmit:(id)sender {
    _remindTimeModel.createTime = [NSDate date];

    [self timeChange:nil];
    if (self.remindTime) {
        if ( [[MedinceRemindTimeManager sharedManager] updateOne:self.remindTime] ) {
            ALERT(@"", @"提醒设置成功。", @"确定");
            [[LocationNotificationBusiness sharedManager] add];
            if (self.block) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            ALERT(@"", @"提醒设置遇到点小问题，请稍后再试。。", @"确定");
        }
    }
    else if ( [[MedinceRemindTimeManager sharedManager] addOne:_remindTimeModel withMedinceRecord:(MedinceRecordModel *)self.medince] ) {
        ALERT(@"", @"提醒设置成功。", @"确定");
        [[LocationNotificationBusiness sharedManager] add];
        if (self.block) {
            self.block();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        ALERT(@"", @"提醒设置遇到点小问题，请稍后再试。。", @"确定");
    }
}
- (void)changePickerTime {
    if (self.remindTime && [self.remindTime valueForKey:@"remindTime"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        self.timePicker.date = [formatter dateFromString:[self.remindTime valueForKey:@"remindTime"]];
    }
}
- (void)timeChange:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSLog(@"picker time is %@", [formatter stringFromDate:self.timePicker.date]);
    _remindTimeModel.remindTime = [formatter stringFromDate:self.timePicker.date];
    if (self.remindTime) {
        [self.remindTime setValue:[formatter stringFromDate:self.timePicker.date] forKey:@"remindTime"];
    }
}
#pragma mark - 私有方法
- (void)buildHourData {
    _hourArr = [NSMutableArray new];
    for (int i=0; i<24; i++) {
        [_hourArr addObject:[self formatNumberToDoubleString:i]];
    }
}
- (void)buildMinuteData {
    _minArr = [NSMutableArray new];
    for (int i=0; i<60; i++) {
        [_minArr addObject:[self formatNumberToDoubleString:i]];
    }
}
- (NSString *)formatNumberToDoubleString:(int)num {
    if (num<10) {
        return [NSString stringWithFormat:@"0%d", num];
    }
    else {
        return [NSString stringWithFormat:@"%d", num];
    }
}
#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _hourArr.count;
    }
    else {
        return _minArr.count;
    }
}

#pragma mark - UIPickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_hourArr objectAtIndex:row];
    }
    else {
        return [_minArr objectAtIndex:row];
    }
//    return @"aaa";
}
@end
