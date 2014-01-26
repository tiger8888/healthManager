//
//  Message.m
//  HealthManager
//
//  Created by PanPeng on 14-1-21.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import "Message.h"

static Message *_sharedManager;


@implementation Message
+ (Message *)sharedManager
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

- (BOOL)checkReturnInfor:(NSDictionary *)dict {
    int r = [[dict categoryObjectForKey:@"retCode"] intValue];

    NSString *message;
    switch (r) {
        case 1:
        {
            return YES;
        }
            break;
        case 2:
        {
            message = @"当前患者没有在系统中注册";
        }
            break;
        case 3:
        {
            message = @"新密码和确认密码不一致";
        }
            break;
        case 4:
        {
            message = @"验证码错误";
        }
            break;
        case 5:
        {
            message = @"验证码已经过期";
        }
            break;
        case 6:
        {
            message = @"旧密码错误";
        }
            break;
        case 99:
        {
            message = @"数据格式错误";//json字符串格式错误
        }
            break;
        default:
            break;
    }
    ALERT(@"提示信息", message, @"确定");
    return NO;
}

- (BOOL)checkLoginReturnInfor:(NSDictionary *)dict {
    int r = [[dict categoryObjectForKey:@"retCode"] intValue];
    
    NSString *message;
    switch (r) {
        case 1:
        {
            return YES;
        }
            break;
        case 2:
        {
            message = @"当前患者没有在系统中注册";
        }
            break;
        case 3:
        {
            message = @"密码错误";
        }
            break;
        default:
            break;
    }
    ALERT(@"提示信息", message, @"确定");
    return NO;

}

- (BOOL)checkBloodList:(NSDictionary *)dict {
    int r = [[[dict categoryObjectForKey:@"resultInfo"]categoryObjectForKey:@"retCode"] intValue];
    
    NSString *message;
    switch (r) {
        case 1:
        {
            return YES;
        }
            break;
        case 2:
        {
            message = @"无血压记录，请录入";
        }
            break;
        
        default:
            break;
    }
    ALERT(@"提示信息", message, @"确定");
    return NO;
    
}

- (BOOL)checkPassword:(NSString *)str {
    if (str.length>0) {
    return YES;
    }
    else {
        ALERT(@"提示信息", @"请输入密码", @"确定");
        return NO;
    }
}

- (BOOL)checkValidationCode:(NSString *)str {
    if (str.length==8) {
        return YES;
    }
    else {
        ALERT(@"提示信息", @"请输入验证码", @"确定");
        return NO;
    }
}

- (BOOL)checkMobile:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
//        NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//            || ([regextestcm evaluateWithObject:mobileNum] == YES)
//            || ([regextestct evaluateWithObject:mobileNum] == YES)
//            || ([regextestcu evaluateWithObject:mobileNum] == YES)
        )
    {
//            if([regextestcm evaluateWithObject:mobileNum] == YES) {
//                NSLog(@"China Mobile");
//            } else if([regextestct evaluateWithObject:mobileNum] == YES) {
//                NSLog(@"China Telecom");
//            } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
//                NSLog(@"China Unicom");
//            } else {
//                NSLog(@"Unknow");
//            }
        return YES;
    }
    else {
        ALERT(@"提示信息", @"请输入正确的手机号码", @"确定");
        return NO;
    }
}

- (BOOL)checkSessionMessage:(NSString *)str {
    if (str.length>0) {
        return YES;
    }
    else {
        ALERT(@"提示信息", @"请输入信息", @"确定");
        return NO;
    }
}

- (BOOL)checkReturnInformationWithInterface:(NSDictionary *)dict {
    int r = [[dict categoryObjectForKey:@"retCode"] intValue];
    
    NSString *message;
    switch (r) {
        case 1:
        {
            return YES;
        }
            break;
        case 2:
        {
            message = @"当前患者没有在系统中注册";
        }
            break;
        case 3:
        {
            message = @"暂无信息";
            return NO;//此种情况不弹出提示信息。
        }
            break;
        default:
            break;
    }
    ALERT(@"提示信息", message, @"确定");
    return NO;
}
@end
