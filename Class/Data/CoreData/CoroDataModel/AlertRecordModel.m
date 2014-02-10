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
- (id)initWithDict:(NSDictionary *)dict;
{
    self = [super init];
    if (self) {
        self.receiveDateStr = [dict categoryObjectForKey:@"creteTime"];
        self.content = [dict categoryObjectForKey:@"msg"];
        self.highPressure = [dict categoryObjectForKey:@"systolicPressure"];
        self.lowPressure = [dict categoryObjectForKey:@"diastolicPressure"];
        self.pulse = [dict categoryObjectForKey:@"pulseRate"];

        self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY];
    }
    return self;
}


- (void)setReceiveDateStr:(NSString *)receiveDateStr {
    _receiveDateStr = receiveDateStr;

    
    static NSDateFormatter *dateFormater;
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    self.receiveDate = [dateFormater dateFromString:receiveDateStr];
}

- (void)setBloodDateStr:(NSString *)bloodDateStr {

    _bloodDateStr = bloodDateStr;
    
    static NSDateFormatter *dateFormater;
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    self.bloodDate = [dateFormater dateFromString:bloodDateStr];
}
@end
