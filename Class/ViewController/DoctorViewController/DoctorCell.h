//
//  DoctorCell.h
//  HealthManager
//
//  Created by LiShuo on 13-12-6.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorModel.h"

@protocol DoctorCellDelegate <NSObject>

- (void)delegateOnClick:(id)cell;

@end

@interface DoctorCell : RootSuperCell


@property (nonatomic, strong) DoctorModel *model;
@property (nonatomic, weak) id <DoctorCellDelegate>delegate;

- (IBAction)cellButtonClick:(id)sender;

@end

