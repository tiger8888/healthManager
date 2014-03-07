//
//  MedinceRecordManager.h
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"
#import "MedinceRecordModel.h"

@interface MedinceRecordManager : BaseManager
+ (id)sharedManager;

- (BOOL)addOne:(MedinceRecordModel *)model;
- (BOOL)updateOne:(NSManagedObject *)model;
- (NSArray *)fetchAll:(NSString *)uid;
- (BOOL)deleteOne:(NSManagedObject *)object;
@end
