//
//  MedinceRecordManager.m
//  HealthManager
//
//  Created by user on 14-2-21.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "MedinceRecordManager.h"

@implementation MedinceRecordManager
+ (id)sharedManager
{
    static MedinceRecordManager *sharedManager;
    
    if (sharedManager == Nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[MedinceRecordManager alloc] init];
            sharedManager.entityName = @"MedinceRecord";
        });
    }
    return sharedManager;
}

- (void)addOne:(MedinceRecordModel *)model
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName  inManagedObjectContext:[self getManagedObjectContext]];
    
    for (NSString *propertyItem in [self propertyList]) {
        [object setValue:[model valueForKey:propertyItem] forKey:propertyItem];
        //        NSLog(@"addOne name %@ value is %@", propertyItem, [model valueForKey:propertyItem]);
    }
    model.id = [NSString stringWithFormat:@"%@", object.objectID];
    NSLog(@"model.id=%@", model.id);
    [self save];
}
-(NSArray *) propertyList {
    return @[@"createTime", @"id", @"name", @"period"];
}
@end
