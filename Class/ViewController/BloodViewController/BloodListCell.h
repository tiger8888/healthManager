//
//  BloodListCell.h
//  HealthManager
//
//  Created by user on 14-2-18.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodListCell : UITableViewCell
{
    __weak IBOutlet UIView *mainCellBackground;

}
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UILabel *mainCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *subCellTitle;
@property (weak, nonatomic) IBOutlet UITableView *subCellTable;
@property (strong, nonatomic) IBOutlet BloodListCell *bloodListCell;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, retain) UIView *parentView;
-(void)setupCell:(NSArray *)data withClickStatus:(NSMutableArray *)clickStatus withIndex:(NSIndexPath *)indexPath;

@property (assign) BOOL isExpanded;

//- (void) rotateExpandBtn:(id)sender;
//- (void) rotateExpandBtnToExpanded;
//- (void) rotateExpandBtnToCollapsed;
//
//+ (int) getHeight;
//+ (int) getsubCellHeight;
@end
