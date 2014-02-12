//
//  Announcement.m
//  HealthManager
//
//  Created by PanPeng on 14-1-17.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "Announcement.h"

@implementation Announcement
@synthesize id, title, content;

- (id)init
{
    return [self initWithId:0 withTitle:@"" withTime:@"" withContent:@""];
}

- (id)initWithId:(int)announcementId withTitle:(NSString *)announcementTitle withTime:(NSString *)announcementTime withContent:(NSString *)announcementContent
{
    self = [super init];
    if (self) {
        self.id = announcementId;
//        if (announcementTitle) {
            self.title = announcementTitle;
//        }
//        else{
//            self.title = @"";
//        }
//        
//        if (announcementContent) {
            self.content = announcementContent;
//        }
//        else{
//            self.content = @"";
//        }
        
        static NSDateFormatter *dateFormater;
        static NSDateFormatter *dateFormaterFromString;
        if (!dateFormater) {
            dateFormater = [[NSDateFormatter alloc] init];
            dateFormater.dateFormat = @"yyyy.MM.dd HH:mm";
            
            dateFormaterFromString = [[NSDateFormatter alloc] init];
            dateFormaterFromString.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
        NSDate *createTime = [dateFormaterFromString dateFromString:announcementTime];
        self.time  = [dateFormater stringFromDate:createTime];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Announcement *new = [[Announcement allocWithZone:zone] init];
    new.id = self.id;
    new.title = self.title;
    new.time = self.time;
    new.content = self.content;
    
    return new;
}
@end
