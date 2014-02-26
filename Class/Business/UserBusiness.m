//
//  UserBusiness.m
//  HealthManager
//
//  Created by user on 14-2-19.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "UserBusiness.h"

static UserBusiness *_sharedManager;

@implementation UserBusiness
+ (UserBusiness *)sharedManager
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
- (void)sendDeviceTokenToServer:(NSData *)str {
    if ([[UserBusiness sharedManager] getCurrentPatientID]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableString *deviceTokenSendKey = [[NSMutableString alloc] initWithString:@"devicetoke_sended_uid_"];
        [deviceTokenSendKey appendString:[[UserBusiness sharedManager] getCurrentPatientID]];
        
        if ( ![[userDefault objectForKey:deviceTokenSendKey] isEqualToString:@"1"] ) {
            NSString *deviceTokenStr = [[str description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
            deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSString *url = [NSString stringWithFormat:@"device/%@/%@.json",[[UserBusiness sharedManager] getCurrentPatientID], deviceTokenStr];
            [[HttpRequestManager sharedManager] requestWithParameters:nil interface:url completionHandle:^(id returnObject) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
                if ( [[Message sharedManager] deviceTokenToServer:[result objectForKey:@"resultInfo"]] ) {
                    [userDefault setObject:@"1" forKey:deviceTokenSendKey];
                }
            } failed:^{
                NSLog(@"网络原因导致设备标识未上传服务器。");
            } hitSuperView:nil method:kGet];
        }
    }
}

- (NSString *)getCurrentPatientID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY];
}
- (NSString *)getCurrentDoctorID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DOCTORID_KEY];
}

@end
