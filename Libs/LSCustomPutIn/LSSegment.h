//
//  LSSegment.h
//  HealthManager
//
//  Created by LiShuo on 13-12-3.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSSegmentDelegate <NSObject>

- (void)segmentDidSelectedAtIndex:(NSUInteger)index;

@end

@interface LSSegment : UIView

- (id)initWithImageArray:(NSArray *)imageNames andHighLightImages:(NSArray *)highLightArray frame:(CGRect)frame superView:(UIView *)superView delegate:(id<LSSegmentDelegate>)delegate;
- (void)setSelectedImage:(NSUInteger)index;
@end
