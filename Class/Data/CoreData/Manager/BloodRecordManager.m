//
//  BloodRecordManager.m
//  HealthManager
//
//  Created by LiShuo on 14-1-14.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "BloodRecordManager.h"


@implementation BloodRecordManager

+ (id)sharedBloodRecordManager
{
    static BloodRecordManager *sharedManager;
    
    if (sharedManager == Nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
           sharedManager = [[BloodRecordManager alloc] init];
        });
    }
    return sharedManager;
}

- (void)addNewRecord:(NSString *)highPressure lowPressure:(NSString *)lowPressure pulse:(NSString *)pulse  date:(NSDate *)date dateStr:(NSString *)dateStr uid:(NSString *)uid
{
//    NSString *str = [self disposeDate:date];

    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"BloodRecordModel"  inManagedObjectContext:[self getManagedObjectContext]];
    [object setValue:highPressure forKey:@"highPressure"];
    [object setValue:lowPressure forKey:@"lowPressure"];
    [object setValue:pulse forKey:@"pulse"];
    [object setValue:date forKey:@"date"];
    [object setValue:dateStr forKey:@"dateStr"];
    [object setValue:uid forKey:@"uid"];
    [self save];
}

- (NSArray *)fetchRecordBy:(NSManagedObject *)model
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BloodRecordModel" inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];

    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"dateStr = %@",[model valueForKey:@"dateStr"]];
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

- (NSArray *)fetchAllMyRecord:(NSString *)uid {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BloodRecordModel" inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
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

- (NSArray *)fetchRecordForUpData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BloodRecordModel" inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid = %@ and submit = NO", [self getCurrentPatientID]];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;

}
#pragma mark - DateData
- (NSString *)disposeDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *str = [formatter stringFromDate:date];
    NSArray *array = [self fetchDateData:str];
    if (array.count > 0) {
        return str;
    }
    [self insertDate:str];
    return str;
}

- (void)insertDate:(NSString *)date
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"BloodRecordDateData"  inManagedObjectContext:[self getManagedObjectContext]];
    [object setValue:date forKey:@"dateStr"];
    [self save];
}

- (NSArray *)fetchDateData:(NSString *)date
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BloodRecordDateData" inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"dateStr = %@",date];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;
}

- (NSArray *)fetchAllDate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BloodRecordDateData" inManagedObjectContext:[self getManagedObjectContext]];
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

#pragma mark - CoreData
- (NSManagedObjectContext *)getManagedObjectContext
{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

- (void)save
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
}

- (NSString *)getCurrentPatientID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY];
}

@end
