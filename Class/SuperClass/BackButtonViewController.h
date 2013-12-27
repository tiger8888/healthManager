//
//  BackButtonViewController.h
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "RootSuperViewController.h"

@interface BackButtonViewController : NavigationBarViewController
{
    UIButton *_backButtonItem;
}

- (void)createBackButton;
@end
