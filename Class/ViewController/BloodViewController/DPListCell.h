//
//  DPBloodListCell.h
//  HealthManager
//
//  Created by user on 14-2-28.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BloodViewController;

static const int height = 54;
static const int subCellHeight = 20;

@interface DPListCell : UITableViewCell
//@property (strong, nonatomic) IBOutlet DPBloodListCell *bloodListCell;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UITableView *subTable;
@property (weak, nonatomic) IBOutlet UIView *separationLine;
@property (nonatomic, assign) BloodViewController *parentTable;

@property (assign) BOOL isExpanded;


+ (int) getHeight;
+ (int) getsubCellHeight;

-(void)setupCell:(NSArray *)data withClickStatus:(NSMutableArray *)clickStatus withIndex:(NSIndexPath *)indexPath;
@end
