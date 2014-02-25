//
//  SetUsingMedinceTimeViewController.m
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SetUsingMedinceTimeViewController.h"
#import "MedinceRemindTimeManager.h"


@interface SetUsingMedinceTimeViewController ()
{
    MedinceRemindTimeModel *_remindTimeModel;
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
    self.timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    self.timePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self.timePicker addTarget:self action:@selector(timeChange:) forControlEvents:UIControlEventValueChanged];
    
    self.name.text = [self.medince valueForKey:@"name"];
    NSLog(@"timepicker locale is %@",self.timePicker.locale.localeIdentifier);
    NSLog(@"id=%@", self.medince.objectID);
    
    _remindTimeModel = [MedinceRemindTimeModel new];
    _remindTimeModel.id = [self.medince valueForKey:@"id"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickDelete:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //删除相应的时间记录
}

- (IBAction)clickSubmit:(id)sender {
    _remindTimeModel.createTime = [NSDate date];
    if ( [[MedinceRemindTimeManager sharedManager] addOne:_remindTimeModel] ) {
        ALERT(@"", @"提醒设置成功。", @"确定");
        if (self.block) {
            self.block();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        ALERT(@"", @"提醒设置遇到点小问题，请稍后再试。。", @"确定");
    }
}

- (void)timeChange:(id)sender {
    if (self.timePicker.date) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        NSLog(@"picker time is %@", [formatter stringFromDate:self.timePicker.date]);
        _remindTimeModel.remindTime = [formatter stringFromDate:self.timePicker.date];
    }
    else {
        ALERT(@"", @"请选择提醒时间。", @"确定");
    }
}
@end
