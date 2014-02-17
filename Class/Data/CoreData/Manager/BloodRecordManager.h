//
//  BloodRecordManager.h
//  HealthManager
//
//  Created by LiShuo on 14-1-14.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BloodRecordManager : NSObject

+ (id)sharedBloodRecordManager;

- (void)addNewRecord:(NSString *)highPressure lowPressure:(NSString *)lowPressure pulse:(NSString *)pulse date:(NSDate *)date dateStr:(NSString *)dateStr uid:(NSString *)uid;
//传入日期模型取出当天录入的所有数据
//注意取出是一个数组现在只要求用最后一次，调用lastObject 方法，将来如果改为平均值forin遍历一遍计算平均值
- (NSArray *)fetchRecordBy:(NSManagedObject *)model;
//取出当下储存的所有日期，应用于历史记录的列表获取数据源
- (NSArray *)fetchAllDate;
- (NSArray *)fetchAllMyRecord:(NSString *)uid;
- (NSArray *)fetchRecordForUpData;
@end
