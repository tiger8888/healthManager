//
//  SessionMessage.m
//  HealthManager
//
//  Created by PanPeng on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SessionMessage.h"

@implementation SessionMessage
@synthesize id;
@synthesize senderId, senderName, sendType;
@synthesize content, timeStamp;
- (id)copyWithZone:(NSZone *)zone
{
    SessionMessage *new = [[SessionMessage allocWithZone:zone] init];
    new.id = self.id;
    new.senderId = self.senderId;
    new.senderName = self.senderName;
    new.sendType = self.sendType;
    new.content = self.content;
    new.timeStamp = self.timeStamp;
    return new;
}
@end
