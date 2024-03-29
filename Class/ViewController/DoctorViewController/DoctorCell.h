//
//  DoctorCell.h
//  HealthManager
//
//  Created by LiShuo on 13-12-6.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DoctorCellDelegate <NSObject>

- (void)delegateOnClick:(id)cell;

@end

@interface DoctorCell : RootSuperCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *department;
@property (strong, nonatomic) IBOutlet UILabel *introduce;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, weak) id <DoctorCellDelegate>delegate;



- (IBAction)cellButtonClick:(id)sender;

@end

