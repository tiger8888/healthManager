//
//  BloodListCell.h
//  HealthManager
//
//  Created by user on 14-2-18.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodListCell : UITableViewCell
@property (nonatomic, assign) BOOL show;
-(void)setupCell:(NSArray *)data withClickStatus:(NSMutableArray *)clickStatus withIndex:(NSIndexPath *)indexPath;
@end
