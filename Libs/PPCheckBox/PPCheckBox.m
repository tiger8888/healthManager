//
//  PPCheckBox.m
//  HealthManager
//
//  Created by user on 14-3-6.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "PPCheckBox.h"

#define PP_CHECKBOX_CHECK_ICON_WIDTH (14)
#define PP_CHECKBOX_TITLE_LEFT (4)

@implementation PPCheckBox
@synthesize checked = _checked;

- (void)dealloc
{
    self.delegate = nil;
}
- (id)initWithDelegate:(id)delegate normalImage:(UIImage *)normalImg selectedImage:(UIImage *)selectedImg {
    self = [super init];
    if (self) {
        self.exclusiveTouch = YES;
        self.delegate = delegate;
        [self setImage:normalImg forState:UIControlStateNormal];
        [self setImage:selectedImg forState:UIControlStateSelected];
        [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setChecked:(BOOL)checked
{
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [self.delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(CGRectGetWidth(contentRect)-PP_CHECKBOX_CHECK_ICON_WIDTH, (CGRectGetHeight(contentRect) - PP_CHECKBOX_CHECK_ICON_WIDTH)/2.0, PP_CHECKBOX_CHECK_ICON_WIDTH, PP_CHECKBOX_CHECK_ICON_WIDTH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(PP_CHECKBOX_TITLE_LEFT, 0,
                      CGRectGetWidth(contentRect) - PP_CHECKBOX_CHECK_ICON_WIDTH,
                      CGRectGetHeight(contentRect));
}

- (void)btnClick {
    self.selected = !self.selected;
    self.checked = self.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [self.delegate didSelectedCheckBox:self checked:self.selected];
    }
}
@end
