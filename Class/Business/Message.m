//
//  Message.m
//  HealthManager
//
//  Created by user on 14-1-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
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
@end
