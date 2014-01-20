//
//  ForgetPasswordSetPWDViewController.m
//  HealthManager
//
//  Created by user on 14-1-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ForgetPasswordSetPWDViewController.h"

@interface ForgetPasswordSetPWDViewController ()

@end

@implementation ForgetPasswordSetPWDViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.validationCode resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}

- (IBAction)updateAndLogin:(id)sender {
}
@end
