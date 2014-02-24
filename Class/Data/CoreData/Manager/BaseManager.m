//
//  BaseManager.m
//  HealthManager
//
//  Created by user on 14-2-10.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "BaseManager.h"

@implementation BaseManager
#pragma mark - CoreData
- (NSManagedObjectContext *)getManagedObjectContext
{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

- (void)save
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
}

- (BOOL)saveReturnFlag {
    if ( [[self getManagedObjectContext] save:nil]) {
//        NSLog(@"ok");
        return YES;
    }
    else {
//        NSLog(@"not ok");
        return NO;
    }
}
@end
