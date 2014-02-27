//
//  LocationNotificationBusiness.m
//  HealthManager
//
//  Created by user on 14-2-26.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "LocationNotificationBusiness.h"
#import "MedinceRecordManager.h"
#import "MedinceRemindTimeManager.h"
#import "MedinceRecordModel.h"
#import "MedinceRemindTimeModel.h"

static LocationNotificationBusiness *_sharedManager;

@implementation LocationNotificationBusiness
+ (LocationNotificationBusiness *)sharedManager
{
    @synchronized(self)
    {
        if (_sharedManager == nil)
        {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedManager == nil)
        {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setEnable:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:enable] forKey:SETTING_REMIND_SOUND_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _enable = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTING_REMIND_SOUND_KEY] boolValue];
    if (!_enable) {
        [self removeAll];
    }
    else {
        [self removeAll];
        [self loadAll];
    }
}

- (BOOL)isEnable {
    _enable =[[[NSUserDefaults standardUserDefaults] objectForKey:SETTING_REMIND_SOUND_KEY] boolValue];
    return  _enable;
}

- (void)add {
    NSLog(@"%s", __FUNCTION__);
    if (self.enable) {
        if ([self existNotification:nil]) {
            [self loadAll];
        }
    }
}

- (void)update:(MedinceRemindTimeModel *)timeObj withPeriod:(MedinceRecordModel *)medinceObj {
    NSLog(@"%s", __FUNCTION__);
    if (self.enable) {
        NSArray *ndata = [self formatPeriodToNumber:timeObj withPeriod:medinceObj.period];
        NSDictionary *data = [ndata firstObject];
        NSString *key = [data valueForKey:@"key"];
        if ([self existNotification:key]) {
            NSString *body = [self formatNotificationBody:medinceObj.name withTime:timeObj.remindTime];
            [self add:body withKey:[data objectForKey:@"key"] withTime:[data objectForKey:@"time"] withRepeat:[[data objectForKey:@"repeat"] intValue]];
        }
        else {
            [self loadAll];
        }
    }

}
- (void)remove:(MedinceRemindTimeModel *)obj withPeriod:(NSString *)period {
    NSLog(@"%s", __FUNCTION__);
    if (self.enable) {
        NSArray *ndata = [self formatPeriodToNumber:obj withPeriod:period];
        NSString *key = [[ndata firstObject] valueForKey:@"key"];
        [self existNotification:key];
    }
}


- (void)removeAll {
    NSLog(@"%s", __FUNCTION__);
    //取消其它本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)loadAll {
    NSLog(@"%s", __FUNCTION__);
    NSArray *result = [[MedinceRecordManager sharedManager] fetchAll:[[UserBusiness sharedManager] getCurrentPatientID]];
    NSLog(@"count=%d", result.count);
    for (MedinceRecordModel *obj in result) {
        NSLog(@"a count = %d", [obj.remindTimeShip count]);
        for (MedinceRemindTimeModel *remindTimeObj in [obj.remindTimeShip allObjects]) {
            NSLog(@"remindTime=%@",remindTimeObj.remindTime);
            NSArray *week = [self formatPeriodToNumber:remindTimeObj withPeriod:obj.period];
//             NSLog(@"week=%@",week);
            if (week) {
                for (NSDictionary *nData in week) {
                    NSString *body = [self formatNotificationBody:obj.name withTime:remindTimeObj.remindTime];
                    [self add:body withKey:[nData objectForKey:@"key"] withTime:[nData objectForKey:@"time"] withRepeat:[[nData objectForKey:@"repeat"] intValue]];
                }
            }
        }
    }
}

- (BOOL)existNotification:(NSString *)key {
    NSArray *arr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (arr.count>0) {
        if ( key.length>0) {
            for (UILocalNotification *item in arr) {
                NSLog(@"exist notification key:%@ value:%@", key, [item.userInfo objectForKey:key]);
                if ([[item.userInfo objectForKey:key] isEqualToString:@"1"]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:item];
                    return YES;
                }
            }
        }
        else {
            return YES;
        }
    }
    else {
        //不存在通知，加载所有通知
        [self loadAll];
    }
    return NO;
}
- (void)add:(NSString *)alertBody withKey:(NSString *)key withTime:(NSDate *)date withRepeat:(int)repeat  {
    UILocalNotification *localNotication = [UILocalNotification new];
    localNotication.applicationIconBadgeNumber = 1;//[self notificationCount];
    localNotication.fireDate = date;//[NSDate dateWithTimeIntervalSinceNow:10];
    localNotication.timeZone = [NSTimeZone defaultTimeZone];
    localNotication.soundName = UILocalNotificationDefaultSoundName; //@"alertsound.wav";
    if (repeat == 1) {
        localNotication.repeatInterval = NSDayCalendarUnit;
    }
    else if ( repeat == 7 ) {
        localNotication.repeatInterval = NSWeekCalendarUnit;
    }
    
//    localNotication.repeatCalendar = nil;
    localNotication.alertBody = alertBody;//@"aaaa";
//    localNotication.alertAction = @"bbb";
//    localNotication.alertLaunchImage = @"btn_bg_red.png";
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"1" forKey:key];
    localNotication.userInfo = userInfo;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotication];
}

- (NSString *)formatNotificationKey:(NSString *)id withPeriod:(int)period withTime:(NSString *)time {
    NSString *str = @"";
    if (id.length>0 && period>0 && time.length>0) {
        str = [NSString stringWithFormat:@"notification_local_usingMedince_%@_%d_%@", id, period, time];
    }
    return str;
}

- (NSString *)formatNotificationBody:(NSString *)medinceName withTime:(NSString *)time {
    NSString *str = @"";
    if (medinceName.length>0 && time.length>0) {
        str = [NSString stringWithFormat:@"%@, 应该吃【%@】", time, medinceName];
    }
    return str;
}

- (NSArray *)formatPeriodToNumber:(MedinceRemindTimeModel *)obj withPeriod:(NSString *)period {
//    NSString *period;

    if (period.length!=7 && obj.remindTime.length<=0) {
        return nil;
    }
    if ([period isEqualToString:@"1111111"]) {
        NSMutableDictionary *notificationData = [NSMutableDictionary new];
        NSString *key = [self formatNotificationKey:obj.id withPeriod:8 withTime:obj.remindTime];
        [notificationData setObject:key forKey:@"key"];
        
        NSDate *remindDate = [self computeDateWithWeek:8 withTime:obj.remindTime];
        [notificationData setObject:remindDate forKey:@"time"];
        [notificationData setObject:@"1" forKey:@"repeat"];
        return [NSArray arrayWithObjects:notificationData, nil];
    }
    else {
        NSMutableArray *week = [NSMutableArray new];
        for (int i=0; i<period.length; i++) {
            if ( [period characterAtIndex:i] == '1') {
                NSMutableDictionary *notificationData = [NSMutableDictionary new];
                int weekIndex = i+1;
                NSString *key = [self formatNotificationKey:obj.id withPeriod:weekIndex withTime:obj.remindTime];
                [notificationData setObject:key forKey:@"key"];
                
                NSDate *remindDate = [self computeDateWithWeek:weekIndex withTime:obj.remindTime];
                [notificationData setObject:remindDate forKey:@"time"];
                [notificationData setObject:@"7" forKey:@"repeat"];
                [week addObject:notificationData];
            }
        }
        if (week.count>0) {
            return week;
        }
        else {
            return nil;
        }
    }
    
}

- (NSDate *)computeDateWithWeek:(int)weekIndex withTime:(NSString *)time {
    NSDateFormatter *formater = [NSDateFormatter new];
    formater.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *nowDate = [NSDate date];
    NSString *returnDateStr;
    
    if ( 0< weekIndex <8 ) {
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:nowDate];
//        NSLog(@"week is %d", [comps weekday]);
//        NSLog(@"index is %d", weekIndex);
        int dayDiff;
        if (weekIndex ==7) {
            //因为week=1是周日，要对周日做特殊处理，4的偏移
            dayDiff = ([comps weekday]-weekIndex + 4+1)*(24*60*60);
        }
        else {
            dayDiff = ([comps weekday]-weekIndex)*(24*60*60);
        }
        returnDateStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSinceNow:dayDiff]];
    }
    else {
        returnDateStr = [formater stringFromDate:nowDate];
    }
//    NSLog(@"now=%@",returnDateStr);
    if (time) {
        returnDateStr = [returnDateStr substringToIndex:11];
        returnDateStr = [returnDateStr stringByAppendingString:time];
    }
//    NSLog(@"now=%@",returnDateStr);
    int forwardTime = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SETTING_REMIND_TIME_KEY]) {
        forwardTime = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTING_REMIND_TIME_KEY] intValue];
    }
    NSDate *returnDate = [formater dateFromString:returnDateStr];
    if (forwardTime>0) {
        returnDate = [NSDate dateWithTimeIntervalSince1970:([returnDate timeIntervalSince1970] - forwardTime*60)];
    }
    return returnDate;
}
/*
 * 暂不使用
 */
- (int)notificationCount {
    NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
    NSString *key = @"notification_local_usingMedince_count";
    int i = [[userDefault objectForKey:key] intValue];
    i++;
    [userDefault setObject:[NSNumber numberWithInt:i] forKey:key];
    return [[userDefault objectForKey:key] intValue];
}

@end
