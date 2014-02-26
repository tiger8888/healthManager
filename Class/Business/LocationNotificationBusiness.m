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

- (void)removeAll {
    //取消其它本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)loadAll {
    NSLog(@"aaa");
    NSArray *result = [[MedinceRecordManager sharedManager] fetchAll:[[UserBusiness sharedManager] getCurrentPatientID]];
    NSLog(@"count=%d", result.count);
    for (MedinceRecordModel *obj in result) {
        NSLog(@"a count = %d", [obj.remindTimeShip count]);
        for (MedinceRemindTimeModel *remindTimeObj in [obj.remindTimeShip allObjects]) {
            NSLog(@"remindTime=%@", remindTimeObj.remindTime);
        }
    }
}

@end
