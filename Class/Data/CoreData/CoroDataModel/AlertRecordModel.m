//
//  AlertRecordModel.m
//  HealthManager
//
//  Created by user on 14-2-10.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "AlertRecordModel.h"

@implementation AlertRecordModel

//@synthesize bloodDate, bloodDateStr;
//@synthesize receiveDate, receiveDateStr;
//@synthesize highPressure, lowPressure, pulse;
//@synthesize content, isRead;

- (void)setReceiveDateStr:(NSString *)receiveDateStr {
    self.receiveDateStr = receiveDateStr;
    
    static NSDateFormatter *dateFormater;
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    self.receiveDate = [dateFormater dateFromString:receiveDateStr];
}

- (void)setBloodDateStr:(NSString *)bloodDateStr {
    self.bloodDateStr = bloodDateStr;
    
    static NSDateFormatter *dateFormater;
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    self.bloodDate = [dateFormater dateFromString:bloodDateStr];
}
@end
