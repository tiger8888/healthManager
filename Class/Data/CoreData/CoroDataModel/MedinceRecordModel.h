//
//  MedinceRecordModel.h
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MedinceRemindTimeModel;

@interface MedinceRecordModel : NSObject
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, retain) NSSet *remindTimeShip;
@end
