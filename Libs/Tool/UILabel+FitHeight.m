//
//  UILabel+FitHeight.m
//  HealthManager
//
//  Created by PanPeng on 14-1-23.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import "UILabel+FitHeight.h"

@implementation UILabel (FitHeight)
- (void)fitHeight {
    CGSize contentSize = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
    CGRect contentRect = [attributedText boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGRect contentFrame = self.frame;//CGRectMake(left, top ,width , ceilf(contentRect.size.height*1.3));
    contentFrame.size.height = contentRect.size.height;
    self.frame = contentFrame;
    
    for (int i=0; i<5; i++) {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}
@end
