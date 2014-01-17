//
//  Announcement.h
//  HealthManager
//
//  Created by user on 14-1-17.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Announcement : NSObject<NSCopying>
@property (nonatomic, strong) NSString *title;
@property (nonatomic) int id;
@property (nonatomic, strong) NSString *content;

- (id)initWithId:(int)announcementId withTitle:(NSString *)announcementTitle withContent:(NSString *)announcementContent;
@end
