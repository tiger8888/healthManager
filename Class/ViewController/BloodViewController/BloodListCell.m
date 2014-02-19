//
//  BloodListCell.m
//  HealthManager
//
//  Created by user on 14-2-18.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "BloodListCell.h"
#import "UILabel+FitHeight.h"

@interface BloodListCell()
{
    NSArray *_data;
    UILabel *_dateLabel;
    UILabel *_bloodLabel;
    UIButton *_detailBtn;
    NSString *_bloodValueFormat;
    NSMutableArray *_clickStatus;
    int _left;
    UIFont *_bloodLabelFont;
    UIFont *_dateLabelFont;
    UIColor *_bloodLabelColor;
    UIColor *_backgroundColor;
}

@end
@implementation BloodListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bloodValueFormat = @"%@--高压%@  低压%@  脉搏%@";
        self.show = NO;
        _left = 8;
        _bloodLabelFont = [UIFont systemFontOfSize:16];
        _dateLabelFont = [UIFont systemFontOfSize:20];
        _bloodLabelColor = UICOLORFROMRGB(0xd6d6d6);
        _backgroundColor = UICOLORFROMRGB(0xc9c9c9);
        // Initialization code
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_left, 6, DEVICE_WIDTH - 80, 20)];
        _dateLabel.font = _dateLabelFont;
        [self.contentView addSubview:_dateLabel];
        
        _bloodLabel = [[UILabel alloc] initWithFrame:CGRectMake(_left, 30, DEVICE_WIDTH - 60, 20)];
        _bloodLabel.font = _bloodLabelFont;
        _bloodLabel.textColor = _bloodLabelColor;
        [self.contentView addSubview:_bloodLabel];
        
//        _detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-100, 0, 20, 20)];
//        _detailBtn
//        [self.contentView addSubview:_detailBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)setupCell:(NSArray *)data  withClickStatus:(NSMutableArray *)clickStatus withIndex:(NSIndexPath *)indexPath{
//    NSLog(@"data count %d",[data count]);
    _data = data;
    _clickStatus = clickStatus;
    
    NSDictionary *itemObj = [_data lastObject];
    _dateLabel.text = [[itemObj objectForKey:@"dateStr"] substringToIndex:10];
    _bloodLabel.text = [NSString stringWithFormat:_bloodValueFormat, [[itemObj objectForKey:@"dateStr"] substringWithRange:NSMakeRange(11, 5)], [itemObj objectForKey:@"highPressure"], [itemObj objectForKey:@"lowPressure"], [itemObj objectForKey:@"pulse"] ];
    NSLog(@"index path:%d",indexPath.row);
    if ([data count] > 1) {
        UIImage *btnBgImage = [UIImage imageNamed:@"arrow_down"];
        _detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-50, 6, 44, 44)];
        _detailBtn.tag = indexPath.row;
        [_detailBtn setBackgroundImage:btnBgImage forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_detailBtn];
        
        if ([_clickStatus[indexPath.row] intValue] == 1) {
            [self loadDetailList];
        }
        else {
            [self unloadDetailList];
        }
        
        [self layoutIfNeeded];
    }
    
}

- (void)showDetail:(id)sender {
    self.show = !self.show;
   
    if (self.show) {
        _clickStatus[_detailBtn.tag] = @1;
        [self loadDetailList];
    }
    else {
        [self unloadDetailList];
    }
    [self layoutIfNeeded];
    [(UITableView *)self.superview reloadData];
//    NSLog(@"click index:%d",_detailBtn.tag);
//    NSLog(@"status:%@",_clickStatus);
}

- (void)loadDetailList {
    UIImage *btnBgImage = [UIImage imageNamed:@"arrow_up"];
    [_detailBtn setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    
    _bloodLabel.hidden = YES;
    int tmpLabelHeight = _bloodLabel.frame.size.height;
    int tmpLabelWidth = _bloodLabel.frame.size.width;
    int tmpY = _bloodLabel.frame.origin.y;
    int tmpX = _bloodLabel.frame.origin.x;
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *itemObj in _data) {
        [str appendString:[NSString stringWithFormat:_bloodValueFormat, [[itemObj objectForKey:@"dateStr"] substringWithRange:NSMakeRange(11, 5)], [self formatBloodValue:[itemObj objectForKey:@"highPressure"]], [self formatBloodValue:[itemObj objectForKey:@"lowPressure"]], [self formatBloodValue:[itemObj objectForKey:@"pulse"]] ]];
        [str appendString:@"\n"];
    }
    NSLog(@"str=%@",str);
    
    UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(tmpX, tmpY, tmpLabelWidth, tmpLabelHeight)];
    tmp.lineBreakMode = UILineBreakModeWordWrap;
    tmp.numberOfLines = 0;
    tmp.text = str;
    tmp.font = _bloodLabelFont;
    tmp.textColor = _bloodLabelColor;
    tmp.backgroundColor = _backgroundColor;
    [tmp fitHeight];
    tmp.tag = 201;
        [self.contentView addSubview:tmp];
    
    _dateLabel.backgroundColor = _backgroundColor;
    UIView *bgViewForCell = [UIView new];
    bgViewForCell.backgroundColor = _backgroundColor;
    self.backgroundView = bgViewForCell;
}

/*
 *2014-02-19暂时作废
 */
- (void)loadDetailList_bak {
    UIImage *btnBgImage = [UIImage imageNamed:@"arrow_up"];
    [_detailBtn setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    
    _bloodLabel.hidden = YES;
    int tmpLabelHeight = _bloodLabel.frame.size.height;
    int tmpLabelWidth = _bloodLabel.frame.size.width;
    int tmpY = _bloodLabel.frame.origin.y;
    int tmpX = _bloodLabel.frame.origin.x;
    int tagIndex = 0;
    for (NSDictionary *itemObj in _data) {
        UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(tmpX, tmpY, tmpLabelWidth, tmpLabelHeight)];
        tmp.text = [NSString stringWithFormat:_bloodValueFormat, [[itemObj objectForKey:@"dateStr"] substringWithRange:NSMakeRange(11, 5)], [itemObj objectForKey:@"highPressure"], [itemObj objectForKey:@"lowPressure"], [itemObj objectForKey:@"pulse"] ];
        tmp.tag = 201+tagIndex;
        tmp.font = _bloodLabelFont;
        tmp.textColor = _bloodLabelColor;
        [self.contentView addSubview:tmp];
        tmpY += 20;
        tagIndex++;
    }
    UIView *bgViewForCell = [UIView new];
    bgViewForCell.backgroundColor = _backgroundColor;
    self.backgroundView = bgViewForCell;
}

- (void)unloadDetailList {
    for (int i=201; ; i++) {
        if ([self viewWithTag:i]) {
            [[self viewWithTag:i] removeFromSuperview];
        }
        else {
            break;
        }
    }
    UIImage *btnBgImage = [UIImage imageNamed:@"arrow_down"];
    [_detailBtn setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    
    _bloodLabel.hidden = NO;
    _clickStatus[_detailBtn.tag] = @2;
    self.backgroundColor = [UIColor clearColor];
    
    _dateLabel.backgroundColor = [UIColor clearColor];
    
    UIView *bgViewForCell = [UIView new];
    bgViewForCell.backgroundColor = [UIColor clearColor];
    self.backgroundView = bgViewForCell;
}

- (NSString *)formatBloodValue:(NSString *)str {
    if (str.length == 1) {
        str = [str stringByAppendingString:@"    "];
    }
    else if (str.length ==2) {
        str = [str stringByAppendingString:@"  "];
    }
    
    return str;
}
@end
