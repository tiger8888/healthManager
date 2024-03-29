//
//  SessionMessage.h
//  HealthManager
//
//  Created by PanPeng on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum  {
    SessionMessageSendTypeMe = 1,
    SessionMessageSendTypeOther
} SessionMessageSendType;

@interface SessionMessage : NSObject<NSCopying>
@property (nonatomic) int id;
@property (nonatomic) int senderId;
@property (nonatomic) int doctorId;
@property (nonatomic) int patientId;
@property (nonatomic, strong) NSString	*senderName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) SessionMessageSendType sendType;
@property (nonatomic, strong) NSString	*timeStamp;
@end
