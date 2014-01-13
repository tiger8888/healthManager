//
//  LSSegment.m
//  HealthManager
//
//  Created by LiShuo on 13-12-3.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "LSSegment.h"

@implementation LSSegment
{
    NSMutableArray *_images;
    NSMutableArray *_selectedImages;
    id<LSSegmentDelegate> _delegate;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        _buttons = [NSMutableArray new];
        _images = [NSMutableArray new];
        _selectedImages = [NSMutableArray new];
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

- (void)initWithImageArray:(NSArray *)imageNames andHighLightImages:(NSArray *)highLightArray frame:(CGRect)frame superView:(UIView *)superView delegate:(id<LSSegmentDelegate>)delegate
{
    UIView *view = [self initWithFrame:frame];
    view.tag = 917;
    self.backgroundColor = [UIColor greenColor];
    CGFloat width = frame.size.width/imageNames.count;
    for (int i = 0; i < imageNames.count; i++)
    {
        
        NSString *imgName = imageNames[i];
        UIImage *image = [UIImage imageNamed:imgName];
        [_images addObject:image];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width *i, 0, width, frame.size.height);
        button.tag = i;
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    if (highLightArray != nil)
    {
        for (NSString *str in highLightArray) {
            UIImage *HightLightImage = [UIImage imageNamed:str];
            [_selectedImages addObject:HightLightImage];
        }
    }
    [superView addSubview:self];
    view = nil;
    _delegate = delegate;
    [self setDefaultImage:0];
}

- (void)setDefaultImage:(NSUInteger)defaultImage
{
//    if (defaultImage <= _images.count)
//    {
        UIButton *button = [self.subviews objectAtIndex:defaultImage];
        [button setImage:_selectedImages[defaultImage] forState:UIControlStateNormal];
//    }
//    else
//    {
//        NSLog(@"数组越界");
//    }
}

- (void)segmentSelected:(UIButton *)button
{
    for (UIButton *btn in [self subviews]) {
        [btn setImage:_images[btn.tag] forState:UIControlStateNormal];
    }
    [button setImage:_selectedImages[button.tag] forState:UIControlStateNormal];
    
    if ([_delegate respondsToSelector:@selector(segmentDidSelectedAtIndex:)])
    {
        [_delegate segmentDidSelectedAtIndex:button.tag];
    }
}
@end
