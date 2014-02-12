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
//        NSLog(@"addOne name %@ value is %@", propertyItem, [model valueForKey:propertyItem]);
    }
    [self save];
}

- (void)updateAllAlertRecordStatusToRead {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:[self getManagedObjectContext]];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isRead == NO AND userID = %@",[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY]];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        for (NSManagedObject *objItem in objs) {
            [objItem setValue:[NSNumber numberWithBool:YES] forKey:@"isRead"];
        }
        [self save];
    }
    else {
        //设置记录状态为已读，不必向用户提示处理结果
    }
}
- (NSArray *)fetchAll
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userID = %@",[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"receiveDate" ascending:NO];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    
    NSMutableArray *result = [NSMutableArray new];

    for (NSManagedObject *item in objs) {
        NSMutableDictionary *resultItem = [NSMutableDictionary new];
        for (NSString *propertyItem in [self propertyList]) {
            id value = [item valueForKey:propertyItem];
//            NSLog(@"property %@ is : %@", propertyItem, value);
            if (!value) {
//                NSLog(@"==========");
                if ([propertyItem isEqualToString:@"bloodDate"] || [propertyItem isEqualToString:@"receiveDate"]) {
                    value =[NSNull null];
                }
                else {
                    value = @" ";
                }
            }
            else if ([propertyItem isEqualToString:@"bloodDateStr"] || [propertyItem isEqualToString:@"receiveDateStr"]) {
                value = [value substringToIndex:[value length]-3];
            }
            [resultItem setObject:[value copy] forKey:propertyItem];
        }
//        NSLog(@"--------------");
        [result addObject:resultItem];
    }
//    NSLog(@"db record count is %d", [result count]);
    return result;
}

-(NSArray *) propertyList {
    return @[@"bloodDate", @"bloodDateStr", @"content", @"highPressure", @"isRead", @"lowPressure", @"pulse", @"receiveDate", @"receiveDateStr", @"highPressureStatus", @"lowPressureStatus", @"pulseStatus",@"userID"];
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
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userID = %@",[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY]];
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dateStr" ascending:YES];
//    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
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
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isRead == NO AND userID = %@",[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY]];
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dateStr" ascending:YES];
//    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;
    
}
@end
