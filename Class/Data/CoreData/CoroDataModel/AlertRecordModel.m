//
//  AlertRecordModel.m
//  HealthManager
//
//  Created by user on 14-2-10.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "AlertRecordModel.h"

static NSDateFormatter *_dateFormater;

@implementation AlertRecordModel

//@synthesize bloodDate, bloodDateStr;
//@synthesize receiveDate, receiveDateStr;
//@synthesize highPressure, lowPressure, pulse;
//@synthesize content, isRead;

- (void)setReceiveDateStr:(NSString *)receiveDateStr {
    if (self.receiveDateStr != receiveDateStr) {
        _receiveDateStr = receiveDateStr;
        
        static NSDateFormatter *dateFormater;
        if (!dateFormater) {
            dateFormater = [[NSDateFormatter alloc] init];
            dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
        
        self.receiveDate = [dateFormater dateFromString:receiveDateStr];
    }
}

- (void)setBloodDateStr:(NSString *)bloodDateStr {
    if (self.bloodDateStr != bloodDateStr) {
        _bloodDateStr = bloodDateStr;
        
        static NSDateFormatter *dateFormater1;
        if (!dateFormater1) {
            dateFormater1 = [[NSDateFormatter alloc] init];
            dateFormater1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
        
        self.bloodDate = [dateFormater1 dateFromString:bloodDateStr];
    }
}
@end
