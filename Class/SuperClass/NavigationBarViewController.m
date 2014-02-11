//
//  NavigationBarViewController.m
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "NavigationBarViewController.h"

@interface NavigationBarViewController ()

@end

@implementation NavigationBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.propertyDict = [[(AppDelegate *)([UIApplication sharedApplication].delegate) propertyList] objectForKey:NSStringFromClass(self.class)];
    }
    return self;
}

- (id)initWithCategory:(NSInteger)category
{
    self = [self init];
    _category = category;
    self.propertyDict = [[(AppDelegate *)([UIApplication sharedApplication].delegate) propertyList] objectAtIndex:_category];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Layout Method

- (void)createNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    _navigationBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation"]];
    _navigationBar.frame = CGRectMake(0, 0, DEVICE_WIDTH, 44);
    _navigationBar.userInteractionEnabled = YES;
    [self.view addSubview:_navigationBar];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
    _titleLabel.center = _navigationBar.center;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _propertyDict[@"titleName"];
    [_navigationBar addSubview:_titleLabel];
}
@end
