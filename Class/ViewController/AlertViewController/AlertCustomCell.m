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
        UIFont *conntFont = [UIFont systemFontOfSize:18.0];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        CGFloat left = 0;
        CGFloat topLineOne = 8;
        CGFloat topLineTwo = topLineOne + 22;
        CGFloat topLineThree = topLineTwo + 22;
        
        
//        NSLog(@"self.frame.size.height=%f", self.superview.frame.size.height);
//        self.content = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.superview.frame.size.height)];//uitextview需要加的代码
        left = 8;
        self.flag = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineOne-4, 14,_heightSingleLineTextLabel)];
        self.flag.backgroundColor = clearColor;
        self.flag.font = [UIFont boldSystemFontOfSize:60];
        [self.contentView addSubview:self.flag];
        
        left = self.flag.frame.size.width + left + 8;
        self.content = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineOne, DEVICE_WIDTH-20,_heightSingleLineTextLabel)];
        self.content.backgroundColor = clearColor;
        self.content.font = conntFont;
//        self.content.editable = NO;//uitextview需要加的代码
//        self.content.dataDetectorTypes = UIDataDetectorTypeLink;//uitextview需要加的代码
//        self.content.scrollEnabled = NO;//uitextview需要加的代码
        [self.contentView addSubview:self.content];
        
        left = 8;
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 120, _heightSingleLineTextLabel)];
        self.timeLabel.backgroundColor = clearColor;
        self.timeLabel.font = font;
        [self.contentView addSubview:self.timeLabel];
        
        left += self.timeLabel.frame.size.width;//124
        self.highLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 34, _heightSingleLineTextLabel)];
        self.highLabel.backgroundColor = clearColor;
        self.highLabel.font = font;
        [self.contentView addSubview:self.highLabel];
        
        left += self.highLabel.frame.size.width - 4;//154
        self.highText = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 24, _heightSingleLineTextLabel)];
        self.highText.backgroundColor = clearColor;
        self.highText.font = font;
        [self.contentView addSubview:self.highText];
        
        left += self.highText.frame.size.width + 10;//188
        self.lowLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 34, _heightSingleLineTextLabel)];
        self.lowLabel.backgroundColor = clearColor;
        self.lowLabel.font = font;
        [self.contentView addSubview:self.lowLabel];
        
        left += self.lowLabel.frame.size.width - 4;//218
        self.lowText = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 24, _heightSingleLineTextLabel)];
        self.lowText.backgroundColor = clearColor;
        self.lowText.font = font;
        [self.contentView addSubview:self.lowText];
        
        left += self.lowText.frame.size.width + 10;//252
        self.pulseLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 34, _heightSingleLineTextLabel)];
        self.pulseLabel.backgroundColor = clearColor;
        self.pulseLabel.font = font;
        [self.contentView addSubview:self.pulseLabel];
        
        left += self.pulseLabel.frame.size.width - 4;//282
        self.pulseText = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineTwo, 24, _heightSingleLineTextLabel)];
        self.pulseText.backgroundColor = clearColor;
        self.pulseText.font = font;
        [self.contentView addSubview:self.pulseText];
        
        left = 8;
        self.receiveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineThree, 98, _heightSingleLineTextLabel)];
        self.receiveTimeLabel.backgroundColor = clearColor;
        self.receiveTimeLabel.font = font;
        [self.contentView addSubview:self.receiveTimeLabel];
        
        left += self.receiveTimeLabel.frame.size.width;//98
        self.receiveTimeText = [[UILabel alloc] initWithFrame:CGRectMake(left, topLineThree, 140, _heightSingleLineTextLabel)];
        self.receiveTimeText.backgroundColor = clearColor;
        self.receiveTimeText.font = font;
        [self.contentView addSubview:self.receiveTimeText];
        
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
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

#pragma mark - Custom Method
-(void)setupCell:(NSManagedObject *)data  withHeight:(CGFloat)height{
    UIColor *flagColor;
    if (![[data valueForKey:@"isRead"] boolValue]) {
        self.content.font = [UIFont boldSystemFontOfSize:18];
        flagColor = [UIColor redColor];
    }
    else {
        flagColor = [UIColor lightGrayColor];
    }
    self.flag.text = @"·";
    self.flag.textColor = flagColor;
    
    self.content.text = [data valueForKey:@"content"]?[data valueForKey:@"content"]:@"";
    self.timeLabel.text = [data valueForKey:@"receiveDateStr"]?[data valueForKey:@"receiveDateStr"]:@"";
    self.highLabel.text = @"高压";
    self.lowLabel.text = @"低压";
    self.pulseLabel.text = @"脉搏";
    if ([[data valueForKey:@"highPressureStatus"] boolValue]) {
        self.highText.textColor = UICOLORFROMRGB(0xe60012);
    }
    if ([[data valueForKey:@"lowPressureStatus"] boolValue]) {
        self.lowText.textColor = UICOLORFROMRGB(0xe60012);
    }
    if ([[data valueForKey:@"pulseStatus"] boolValue]) {
        self.pulseText.textColor = UICOLORFROMRGB(0xe60012);
    }
    self.highText.text = [data valueForKey:@"highPressure"]?[data valueForKey:@"highPressure"]:@"";
    self.lowText.text = [data valueForKey:@"lowPressure"]?[data valueForKey:@"lowPressure"]:@"";
    self.pulseText.text = [data valueForKey:@"pulse"]?[data valueForKey:@"pulse"]:@"";
    self.receiveTimeLabel.text = @"消息接收时间";
    self.receiveTimeText.text = [data valueForKey:@"receiveDateStr"]?[data valueForKey:@"receiveDateStr"]:@"";
    
//    [self controlPosition:height];//uitextview需要加的代码
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
