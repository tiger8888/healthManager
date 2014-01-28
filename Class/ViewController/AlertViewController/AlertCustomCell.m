//
//  AlertCustomCell.m
//  HealthManager
//
//  Created by user on 14-1-28.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "AlertCustomCell.h"

@implementation AlertCustomCell

#pragma mark - TableViewCell Method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _heightSingleLineTextLabel = 20.0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIColor *clearColor = [UIColor clearColor];
        CGFloat left = 0;
        CGFloat topLineTwo = 70;
        CGFloat topLineThree = 92;
        
        
        NSLog(@"self.frame.size.height=%f", self.superview.frame.size.height);
        self.content = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.superview.frame.size.height)];
        self.content.backgroundColor = clearColor;
        self.content.font = [UIFont systemFontOfSize:14.0];
        self.content.editable = NO;
        self.content.dataDetectorTypes = UIDataDetectorTypeLink;
        self.content.scrollEnabled = NO;
        [self.contentView addSubview:self.content];
        
        left = 8;
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 120, _heightSingleLineTextLabel)];
        self.timeLabel.backgroundColor = clearColor;
        self.timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.timeLabel];
        
        left += self.timeLabel.frame.size.width;//124
        self.highLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 34, _heightSingleLineTextLabel)];
        self.highLabel.backgroundColor = clearColor;
        self.highLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.highLabel];
        
        left += self.highLabel.frame.size.width - 4;//154
        self.highText = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 24, _heightSingleLineTextLabel)];
        self.highText.backgroundColor = clearColor;
        self.highText.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.highText];
        
        left += self.highText.frame.size.width + 10;//188
        self.lowLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 34, _heightSingleLineTextLabel)];
        self.lowLabel.backgroundColor = clearColor;
        self.lowLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.lowLabel];
        
        left += self.lowLabel.frame.size.width - 4;//218
        self.lowText = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 24, _heightSingleLineTextLabel)];
        self.lowText.backgroundColor = clearColor;
        self.lowText.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.lowText];
        
        left += self.lowText.frame.size.width + 10;//252
        self.pulseLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 34, _heightSingleLineTextLabel)];
        self.pulseLabel.backgroundColor = clearColor;
        self.pulseLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.pulseLabel];
        
        left += self.pulseLabel.frame.size.width - 4;//282
        self.pulseText = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 24, _heightSingleLineTextLabel)];
        self.pulseText.backgroundColor = clearColor;
        self.pulseText.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.pulseText];
        
        left = 8;
        self.receiveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineThree, 98, _heightSingleLineTextLabel)];
        self.receiveTimeLabel.backgroundColor = clearColor;
        self.receiveTimeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.receiveTimeLabel];
        
        left += self.receiveTimeLabel.frame.size.width;//98
        self.receiveTimeText = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineThree, 120, _heightSingleLineTextLabel)];
        self.receiveTimeText.backgroundColor = clearColor;
        self.receiveTimeText.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.receiveTimeText];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Custom Method
-(void)setupCell:(NSDictionary *)data  withHeight:(CGFloat)height{
    self.content.text = [data objectForKey:@"msg"];
    self.timeLabel.text = [data objectForKey:@"createTime"];
    self.highLabel.text = @"高压";
    self.lowLabel.text = @"低压";
    self.pulseLabel.text = @"脉搏";
    self.highText.text = [data objectForKey:@"systolicPressure"];
    self.lowText.text = [data objectForKey:@"diastolicPressure"];
    self.pulseText.text = [data objectForKey:@"pressId"];
    self.receiveTimeLabel.text = @"消息接收时间";
    self.receiveTimeText.text = [data objectForKey:@"createTime"];
    
    [self controlPosition:height];
}

-(void)controlPosition:(CGFloat)height{
    CGFloat y = 0.0;
    CGRect frame = CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, self.content.frame.size.width, height-22);
    self.content.frame = frame;

    y = self.content.bounds.size.height + self.content.frame.origin.y - 14;// + 14;
    self.timeLabel.frame = [self setViewOriginY:self.timeLabel withY:y];
    self.highLabel.frame = [self setViewOriginY:self.highLabel withY:y];
    self.highText.frame = [self setViewOriginY:self.highText withY:y];
    self.lowLabel.frame = [self setViewOriginY:self.lowLabel withY:y];
    self.lowText.frame = [self setViewOriginY:self.lowText withY:y];
    self.pulseLabel.frame = [self setViewOriginY:self.pulseLabel withY:y];
    self.pulseText.frame = [self setViewOriginY:self.pulseText withY:y];
    
    y += 14;
    self.receiveTimeLabel.frame = [self setViewOriginY:self.receiveTimeLabel withY:y];
    self.receiveTimeText.frame = [self setViewOriginY:self.receiveTimeText withY:y];


    
    [self.content layoutIfNeeded];
    [self.timeLabel layoutIfNeeded];
    [self.highLabel layoutIfNeeded];
    [self.highText layoutIfNeeded];
    [self.lowLabel layoutIfNeeded];
    [self.lowText layoutIfNeeded];
    [self.pulseLabel layoutIfNeeded];
    [self.pulseText layoutIfNeeded];
    [self.receiveTimeLabel layoutIfNeeded];
    [self.receiveTimeText layoutIfNeeded];
    
}

-(CGRect)setViewOriginY:(UIView *)view withY:(CGFloat)y {
    return CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
}
@end
