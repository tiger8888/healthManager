//
//  NavigationBarViewController.h
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "RootSuperViewController.h"

@interface NavigationBarViewController : RootSuperViewController
{
    UIImageView *_navigationBar;
    UILabel *_titleLabel;
    NSUInteger _category;
}

@property (nonatomic, strong) NSDictionary *propertyDict;

- (id)initWithCategory:(NSInteger)category;
@end
