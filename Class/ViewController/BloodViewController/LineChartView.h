//
//  LineChartView.h
//  DrawDemo
//
//  Created by 潘朋 dream on 2014-01-01.
//  Copyright (c) 2014年 dreaminto.com.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LineChartView : UIView

//横竖轴距离间隔
@property (nonatomic, assign) NSInteger hGap;
@property (nonatomic, assign) NSInteger vGap;

//横竖轴显示标签
@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;

//点信息
@property (nonatomic, strong) NSArray *bloodArray;

@end
