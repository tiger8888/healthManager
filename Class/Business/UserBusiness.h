//
//  UserBusiness.h
//  HealthManager
//
//  Created by user on 14-2-19.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBusiness : NSObject
+ (UserBusiness *)sharedManager;

- (void)sendDeviceTokenToServer:(NSData *)str;
- (NSString *)getCurrentPatientID;
- (NSString *)getCurrentDoctorID;
@end
