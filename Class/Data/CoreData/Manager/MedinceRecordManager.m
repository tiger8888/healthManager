//
//  MedinceRecordManager.m
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "MedinceRecordManager.h"
#import "MedinceRemindTimeManager.h"

@implementation MedinceRecordManager
+ (id)sharedManager
{
    static MedinceRecordManager *sharedManager;
    
    if (sharedManager == Nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[MedinceRecordManager alloc] init];
            sharedManager.entityName = @"Medince";
        });
    }
    return sharedManager;
}

- (BOOL)addOne:(MedinceRecordModel *)model
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName  inManagedObjectContext:[self getManagedObjectContext]];
    
    for (NSString *propertyItem in [self propertyList]) {
        [object setValue:[model valueForKey:propertyItem] forKey:propertyItem];
                NSLog(@"addOne name :%@ value :%@", propertyItem, [model valueForKey:propertyItem]);
    }
    NSString *idStr = [self getObjectIdString:object];
    NSLog(@"id=%@", idStr);
    model.id = idStr;
    [object setValue:idStr forKey:@"id"];
//    [self save];
    if ( [self saveReturnFlag] ) {
        return YES;
    }
    else {
        return NO;
    }
//    return YES;
}

- (NSArray *)fetchAll:(NSString *)uid {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *item in objs) {
        NSLog(@"obj name is %@", [item valueForKey:@"name"]);
        NSLog(@"obj id is %@", [item valueForKey:@"id"]);
    }
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;
}

- (BOOL)deleteOne:(NSManagedObject *)object {
    [[self getManagedObjectContext] deleteObject:object];
    
    NSSet *detailSet = [[object valueForKey:@"remindTimeShip"] copy];
    for (NSManagedObject *detailObj in detailSet) {
        [[MedinceRemindTimeManager sharedManager] deleteOne:detailObj];
    }
    
    return [self saveReturnFlag];
}

-(NSArray *) propertyList {
    return @[@"createTime", @"id", @"name", @"period", @"uid"];
}
@end
