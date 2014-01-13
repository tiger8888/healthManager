//
//  BloodRecordModel.m
//  HealthManager
//
//  Created by LiShuo on 14-1-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "BloodRecordModel.h"

@implementation BloodRecordModel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.highPressure = [aDecoder decodeObjectForKey:@"highPressure"];
        self.lowPressure = [aDecoder decodeObjectForKey:@"lowPressure"];
        self.pulse = [aDecoder decodeObjectForKey:@"pulse"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.submit = [aDecoder decodeBoolForKey:@"submit"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_highPressure forKey:@"highPressure"];
    [aCoder encodeObject:_lowPressure forKey:@"lowPressure"];
    [aCoder encodeObject:_pulse forKey:@"pulse"];
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeBool:_submit forKey:@"submit"];
}

- (id)initWithHighPressure:(NSString *)HighPressure lowPressure:(NSString *)lowPressure pulse:(NSString *)pulse date:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        self.highPressure = HighPressure;
        self.lowPressure = lowPressure;
        self.pulse = pulse;
        self.date = date;
        self.submit = NO;
    }

    return self;
}

@end
