//
//  AlertCustomCell.h
//  HealthManager
//
//  Created by user on 14-1-28.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertCustomCell : UITableViewCell
{
    CGFloat _heightSingleLineTextLabel;
}
@property (nonatomic, retain) UITextView *content;
@property (nonatomic, retain) UILabel *timeLabel;

@property (nonatomic, retain) UILabel *highLabel;
@property (nonatomic, retain) UILabel *highText;
@property (nonatomic, retain) UILabel *lowLabel;
@property (nonatomic, retain) UILabel *lowText;
@property (nonatomic, retain) UILabel *pulseLabel;
@property (nonatomic, retain) UILabel *pulseText;
@property (nonatomic, retain) UILabel *receiveTimeLabel;
@property (nonatomic, retain) UILabel *receiveTimeText;

-(void)setupCell:(NSDictionary *)data withHeight:(CGFloat)height;
@end
