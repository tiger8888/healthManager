//
//  BloodRecordQueue.m
//  HealthManager
//
//  Created by LiShuo on 14-1-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "BloodRecordQueue.h"

@implementation BloodRecordQueue

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.queue = [aDecoder decodeObjectForKey:@"queue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_queue forKey:@"queue"];
}
@end
