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
- (BOOL)addOne:(MedinceRemindTimeModel *)model withMedinceRecord:(MedinceRecordModel *)medinceRecord;
- (BOOL)updateOne:(NSManagedObject *)object;
- (BOOL)deleteOne:(NSManagedObject *)object;
- (NSArray *)fetchAll:(NSString *)id;
- (NSArray *)fetchAllWithUid:(NSString *)uid;
@end
