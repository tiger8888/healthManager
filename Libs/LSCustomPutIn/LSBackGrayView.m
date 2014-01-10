//
//  LSBackGrayView.m
//  HealthManager
//
//  Created by LiShuo on 13-12-7.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "LSBackGrayView.h"

@implementation LSBackGrayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.hidden = YES;
    [self removeFromSuperview];

}
@end
