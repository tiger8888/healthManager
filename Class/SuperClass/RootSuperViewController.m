//
//  RootSuperViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "RootSuperViewController.h"

@interface RootSuperViewController ()

@end

@implementation RootSuperViewController

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
    
    [self setViewFrameForiOS7];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Layout Method
- (void)setViewFrameForiOS7
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.view.bounds = CGRectMake(0, -20, DEVICE_WIDTH, DEVICE_HEIGHT -20);
    }
}

@end
