//
//  LocationNotificationBusiness.h
//  HealthManager
//
//  Created by user on 14-2-26.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationNotificationBusiness : NSObject
{
    BOOL _enable;
}
+ (LocationNotificationBusiness *)sharedManager;
- (void)removeAll;
- (void)add;
- (void)loadAll;
- (void)remove:(NSString *)key;
- (void)update:(NSDictionary *)info;
@property (nonatomic, assign, getter=isEnable, setter=setEnable:) BOOL enable;

@end
