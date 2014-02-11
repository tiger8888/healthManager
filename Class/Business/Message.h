//
//  Message.h
//  HealthManager
//
//  Created by PanPeng on 14-1-21.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
+ (Message *)sharedManager;

- (BOOL)checkReturnInfor:(NSDictionary *)dict;
- (BOOL)checkLoginReturnInfor:(NSDictionary *)dict;
- (BOOL)checkBloodList:(NSDictionary *)dict;
- (BOOL)checkPassword:(NSString *)str;
- (BOOL)checkValidationCode:(NSString *)str;
- (BOOL)checkMobile:(NSString *)mobileNum;
- (BOOL)checkSessionMessage:(NSString *)str;
- (BOOL)checkReturnInformationWithInterface:(NSDictionary *)dict;
- (void)bloodDataUpdateToServer:(NSDictionary *)dict;
@end
