//
//  DoctorModel.m
//  HealthManager
//
//  Created by 李硕 on 13-12-19.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "DoctorModel.h"

@implementation DoctorModel

- (void)setDetail:(NSString *)detail
{
    CGSize size = [detail sizeWithFont:FONT_DETAIL forWidth:DEVICE_WIDTH -20 lineBreakMode:NSLineBreakByCharWrapping];
    self.height = size.height;
}

@end
