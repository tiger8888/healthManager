//
//  TakeMedicineRemindViewController.m
//  HealthManager
//
//  Created by user on 14-2-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "TakeMedicineRemindViewController.h"
#import "MedinceAddViewController.h"
#import "SetUsingMedinceTimeViewController.h"

@interface TakeMedicineRemindViewController ()

@end

@implementation TakeMedicineRemindViewController

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
    [self addAddButtonOnNavigation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAddButtonOnNavigation {
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(DEVICE_WIDTH - 54, 0, 44, 44);
    [addBtn setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addMedince:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:addBtn];
}

- (void)addMedince:(id)sender {
    MedinceAddViewController *medinceAddCtl = [[MedinceAddViewController alloc] initWithCategory:21];
    [self presentViewController:medinceAddCtl animated:YES completion:nil];
}

@end
