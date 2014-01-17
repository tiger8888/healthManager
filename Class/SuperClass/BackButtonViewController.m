//
//  BackButtonViewController.m
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "BackButtonViewController.h"

@interface BackButtonViewController ()

@end

@implementation BackButtonViewController

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
	// Do any additional setup after loading the view.
    [self createBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Method
- (void)createBackButton
{
    _backButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButtonItem.frame = CGRectMake(10, 0, 44, 44);
    [_backButtonItem setImage:[UIImage imageNamed:@"bbi_left"] forState:UIControlStateNormal];
    [_backButtonItem addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:_backButtonItem];
}

#pragma mark - Event Method
- (void)backButtonClick
{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
