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

- (id)initWithDict:(NSDictionary *)dict;
{
    self = [super init];
    if (self) {
        self.receiveDateStr = [dict categoryObjectForKey:@"receiveTime"];
        self.bloodDateStr = [dict categoryObjectForKey:@"createTime"];
        self.content = [dict categoryObjectForKey:@"msg"];
        self.highPressure = [dict categoryObjectForKey:@"systolicPressure"];
        self.lowPressure = [dict categoryObjectForKey:@"diastolicPressure"];
        self.pulse = [dict categoryObjectForKey:@"pulseRate"];
        
        NSString *flag = [dict categoryObjectForKey:@"wainflag"];
        self.highPressureStatus = [[flag substringToIndex:1] boolValue];
        self.lowPressureStatus = [[flag substringWithRange:NSMakeRange(1, 1)] boolValue];
        self.pulseStatus = [[flag substringFromIndex:2] boolValue];
        
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
        
    static NSDateFormatter *dateFormater1;
    if (!dateFormater1) {
        dateFormater1 = [[NSDateFormatter alloc] init];
        dateFormater1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    self.bloodDate = [dateFormater1 dateFromString:bloodDateStr];
}
@end
