//
//  BloodRecordModel.h
//  HealthManager
//
//  Created by LiShuo on 14-1-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodRecordModel : NSObject

@property (nonatomic, copy) NSString *highPressure;
@property (nonatomic, copy) NSString *lowPressure;
@property (nonatomic, copy) NSString *pulse;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL submit;
@property (nonatomic, copy) NSString *uid;

@end
