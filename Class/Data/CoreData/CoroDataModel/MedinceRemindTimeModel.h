//
//  MedinceRemindTimeModel.h
//  HealthManager
//
//  Created by user on 14-2-25.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedinceRemindTimeModel : NSObject
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSString *remindTime;
@end
