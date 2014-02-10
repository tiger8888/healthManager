//
//  AlertRecordModel.h
//  HealthManager
//
//  Created by user on 14-2-10.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertRecordModel : NSObject
@property (nonatomic, strong) NSDate *bloodDate;
@property (nonatomic, copy) NSString *bloodDateStr;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *highPressure;
@property (nonatomic, assign) BOOL *isRead;
@property (nonatomic, copy) NSString *lowPressure;
@property (nonatomic, copy) NSString *pulse;
@property (nonatomic, strong) NSDate *receiveDate;
@property (nonatomic, copy) NSString *receiveDateStr;
@end
