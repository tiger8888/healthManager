//
//  MedinceRemindTimeManager.m
//  HealthManager
//
//  Created by user on 14-2-25.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "MedinceRemindTimeManager.h"

@implementation MedinceRemindTimeManager
+ (id)sharedManager
{
    static MedinceRemindTimeManager *sharedManager;
    
    if (sharedManager == Nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[MedinceRemindTimeManager alloc] init];
            sharedManager.entityName = @"MedicineRemindTime";
        });
    }
    return sharedManager;
}

- (BOOL)addOne:(MedinceRecordModel *)model
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName  inManagedObjectContext:[self getManagedObjectContext]];
    
    for (NSString *propertyItem in [self propertyList]) {
        [object setValue:[model valueForKey:propertyItem] forKey:propertyItem];
        //        NSLog(@"addOne name %@ value is %@", propertyItem, [model valueForKey:propertyItem]);
    }

    return [self saveReturnFlag];
}

- (BOOL)updateOne:(NSManagedObject *)object {
    return [self saveReturnFlag];
}

- (BOOL)deleteOne:(NSManagedObject *)object {
    [[self getManagedObjectContext] deleteObject:object];
    return [self saveReturnFlag];
}

- (NSArray *)fetchAll:(NSString *)id {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    //    for (NSManagedObject *item in objs) {
    //        NSLog(@"obj name is %@", [item valueForKey:@"name"]);
    //    }
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;
}

- (NSArray *)fetchAllWithUid:(NSString *)uid {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"1=1"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    //    for (NSManagedObject *item in objs) {
    //        NSLog(@"obj name is %@", [item valueForKey:@"name"]);
    //    }
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;
}


-(NSArray *) propertyList {
    return @[@"createTime", @"id", @"remindTime"];
}
@end
