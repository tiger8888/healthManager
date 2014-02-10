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

- (NSArray *)fetchAll
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"receiveDate" ascending:NO];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [[self getManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    
    NSMutableArray *result = [NSMutableArray new];
    NSMutableDictionary *resultItem = [NSMutableDictionary new];
    for (NSManagedObject *item in objs) {
        for (NSString *propertyItem in [self propertyList]) {
            id value = [item valueForKey:propertyItem];
//            NSLog(@"property content is : %@", value);
            if (!value) {
//                NSLog(@"==========");
                if ([propertyItem isEqualToString:@"bloodDate"] || [propertyItem isEqualToString:@"receiveDate"]) {
                    value =[NSNull null];
                }
                else {
                    value = @" ";
                }
            }
            [resultItem setObject:value forKey:propertyItem];
        }
//        NSLog(@"--------------");
        [result addObject:resultItem];
    }
    return result;
}

-(NSArray *) propertyList {
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
@end
