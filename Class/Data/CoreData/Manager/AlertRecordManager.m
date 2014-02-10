//
//  AlertRecordManager.m
//  HealthManager
//
//  Created by user on 14-2-10.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "AlertRecordManager.h"
#import "AlertRecordModel.h"

@implementation AlertRecordManager
- (void)addOne:(AlertRecordModel *)model
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName  inManagedObjectContext:[self getManagedObjectContext]];

    for (NSString *propertyItem in [self propertyList]) {
        [object setValue:[model valueForKey:propertyItem] forKey:propertyItem];
    }
    [self save];
}

-(NSArray *) propertyList
{
    return @[@"bloodDate", @"bloodDateStr", @"content", @"highPressure", @"isRead", @"lowPressure", @"pulse", @"receiveDate", @"receiveDateStr"];
}

+ (id)sharedManager
{
    static AlertRecordManager *sharedManager;
    
    if (sharedManager == Nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[AlertRecordManager alloc] init];
            sharedManager.entityName = @"AlertRecordModel";
        });
    }
    return sharedManager;
}

- (NSArray *)fetchAllDate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlertRecordModel" inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dateStr" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;

}

- (NSArray *)fetchUnread
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlertRecordModel" inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isRead == NO"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dateStr" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;
    
}

@end
