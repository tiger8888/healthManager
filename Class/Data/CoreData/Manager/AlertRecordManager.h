//
//  AlertRecordManager.h
//  HealthManager
//
//  Created by user on 14-2-10.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"

@class AlertRecordModel;

@interface AlertRecordManager : BaseManager

+ (id)sharedManager;

- (void)addOne:(AlertRecordModel *)model;

//- (NSArray *)fetchBy:(NSManagedObject *)model;
- (NSArray *)fetchAll;
//- (NSArray *)fetchRecordForUpData;
@end
