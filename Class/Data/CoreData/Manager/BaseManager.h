//
//  BaseManager.h
//  HealthManager
//
//  Created by user on 14-2-10.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseManager : NSObject
@property (nonatomic, assign) NSString *entityName;

- (NSManagedObjectContext *)getManagedObjectContext;
- (void)save;
- (BOOL)saveReturnFlag;
- (NSString *)getObjectIdString:(NSManagedObject *)object;
@end
