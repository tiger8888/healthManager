//
//  Algorithm.h
//  HealthManager
//
//  Created by user on 14-1-28.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Algorithm : NSObject

-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)width;
//计算Cell的高度
-(CGFloat)calculation:(NSIndexPath *)indexPath data:(NSArray *)data;

@end
