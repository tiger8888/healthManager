//
//  MedinceRemindTimeManager.h
//  HealthManager
//
//  Created by user on 14-2-25.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"
#import "MedinceRecordModel.h"
#import "MedinceRemindTimeModel.h"

@interface MedinceRemindTimeManager : BaseManager
+ (id)sharedManager;

- (BOOL)addOne:(MedinceRemindTimeModel *)model;
- (NSArray *)fetchAll:(NSString *)id;
@end
