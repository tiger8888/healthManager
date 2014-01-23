//
//  ViewBuilder.m
//  HealthManager
//
//  Created by PanPeng on 14-1-23.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import "ViewBuilder.h"

static ViewBuilder *_sharedManager;


@implementation ViewBuilder
+ (ViewBuilder *)sharedManager
{
    @synchronized(self)
    {
        if (_sharedManager == nil)
        {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedManager == nil)
        {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (UILabel *)LabelWithMultiLinesFitHeight:(NSString *)str withLeft:(int)left withTop:(int)top withWidth:(int)width  withFont:(UIFont *)font {
    CGSize contentSize = CGSizeMake(width, CGFLOAT_MAX);
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font}];
    CGRect contentRect = [attributedText boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGRect contentFrame = CGRectMake(left, top ,width , ceilf(contentRect.size.height*1.3));
    
    UILabel *label = [[UILabel alloc] initWithFrame:contentFrame];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = str;
    
    return label;
}

@end
