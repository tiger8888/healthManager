//
//  LocationNotificationBusiness.h
//  HealthManager
//
//  Created by user on 14-2-26.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MedinceRemindTimeModel;
@class MedinceRecordModel;

@interface LocationNotificationBusiness : NSObject
{
    BOOL _enable;
}
+ (LocationNotificationBusiness *)sharedManager;
- (void)removeAll;
- (void)add;
- (void)loadAll;
- (void)remove:(MedinceRemindTimeModel *)obj withPeriod:(NSString *)period;
- (void)update:(MedinceRemindTimeModel *)timeObj withPeriod:(MedinceRecordModel *)medinceObj;

@property (nonatomic, assign, getter=isEnable, setter=setEnable:) BOOL enable;

@end
