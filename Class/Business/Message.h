//
//  Message.h
//  HealthManager
//
//  Created by user on 14-1-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
+ (Message *)sharedManager;

- (BOOL)checkReturnInfor:(NSDictionary *)dict;
- (BOOL)checkLoginReturnInfor:(NSDictionary *)dict;
@end
