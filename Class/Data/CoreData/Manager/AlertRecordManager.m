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
