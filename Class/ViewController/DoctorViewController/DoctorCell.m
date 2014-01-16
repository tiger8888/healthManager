//
//  DoctorCell.m
//  HealthManager
//
//  Created by LiShuo on 13-12-6.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "DoctorCell.h"

@implementation DoctorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.selectionStyle = UITableViewCellSelectionStyleGray;
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



- (IBAction)cellButtonClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(delegateOnClick:)]) {
        [_delegate delegateOnClick:self];
    }
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    _name.text = [_model objectForKey:@"name"];
    _title.text = [_model objectForKey:@"profesTitle"];
//    _department.text = [_model objectForKey:@"office"];
    _introduce.text = [NSString stringWithFormat:@"擅长及简介:%@",[_model objectForKey:@"profesIntro"]];
    NSString *url = [_model objectForKey:@"picUrl"];
    if ([url isKindOfClass:[NSNull class]]) {
        _profileImage.image = [UIImage imageNamed:@"defaultProfile"];
    }
    else
    {
        [_profileImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultProfile"]];
     }
}
@end
