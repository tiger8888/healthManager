//
//  Announcement.h
//  HealthManager
//
//  Created by PanPeng on 14-1-17.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Announcement : NSObject<NSCopying>
@property (nonatomic, strong) NSString *title;
@property (nonatomic) int id;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSString *content;

- (id)initWithId:(int)announcementId withTitle:(NSString *)announcementTitle withTime:(NSString *)announcementTime withContent:(NSString *)announcementContent;
@end
