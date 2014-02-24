//
//  SetUsingMedinceTimeViewController.m
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SetUsingMedinceTimeViewController.h"

@interface SetUsingMedinceTimeViewController ()

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
}

- (void)timeChange:(id)sender {
    NSLog(@"value is %@", self.timePicker.date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
}
@end
