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
    return [self initWithId:0 withTitle:@"" withContent:@""];
}

- (id)initWithId:(int)announcementId withTitle:(NSString *)announcementTitle withContent:(NSString *)announcementContent
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
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Announcement *new = [[Announcement allocWithZone:zone] init];
    new.id = self.id;
    new.title = self.title;
    new.content = self.content;
    
    return new;
}
@end
