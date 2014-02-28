//
//  BloodViewController.h
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "RootSuperViewController.h"
#import "LSSegment.h"
#import "BloodListCell.h"
#import "DPListCell.h"

@interface BloodViewController : SuperListViewController <LSSegmentDelegate>
@property (nonatomic, retain) BloodListCell *bloodListCell;
//@property (nonatomic, retain) DPBloodListCell *dpbloodListCell;
- (void) collapsableButtonTapped: (UIControl *)button withEvent: (UIEvent *)event;
@end
