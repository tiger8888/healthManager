//
//  BloodRecordQueue.h
//  HealthManager
//
//  Created by LiShuo on 14-1-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodRecordQueue : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray *queue;

@end
