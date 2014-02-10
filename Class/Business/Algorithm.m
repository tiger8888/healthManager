//
//  Algorithm.m
//  HealthManager
//
//  Created by user on 14-1-28.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "Algorithm.h"
#define kTextViewPadding            16.0
#define kLineBreakMode1              UILineBreakModeWordWrap
@implementation Algorithm

-(CGFloat)calculation:(NSIndexPath *)indexPath data:(NSArray *)data {
    NSInteger row = indexPath.row;
    if (row >= [data count]) {
        return 1;
    }
    NSDictionary* item = [data objectAtIndex:row];
    
    CGFloat height  = 0.0f;
    
    height = [self cellHeight:[item objectForKey:@"content"] with:DEVICE_WIDTH];
    
    return height;
}

-(CGFloat)cellHeight:(NSString *)contentText with:(CGFloat)width
{
    UIFont* font = [UIFont systemFontOfSize:14];

    CGSize contentSize = CGSizeMake(width - kTextViewPadding, CGFLOAT_MAX);
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:contentText attributes:@{NSFontAttributeName:font}];
    CGRect contentRect = [attributedText boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];

    CGFloat height = contentRect.size.height + 44;
    return height;
}
@end
