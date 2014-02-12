//
//  Knowledge.m
//  HealthManager
//
//  Created by PanPeng on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "Knowledge.h"

@implementation Knowledge
@synthesize id, title, content;

- (id)init
{
    return [self initWithId:0 withTitle:@"" withTime:@"" withContent:@""];
}

- (id)initWithId:(int)knowledgeId withTitle:(NSString *)knowledgeTitle withTime:(NSString *)knowledgeTime withContent:(NSString *) knowledgeContent {
    self = [super init];
    if (self) {
        self.id = knowledgeId;
        self.title = knowledgeTitle;
        self.content = knowledgeContent;
        
        static NSDateFormatter *dateFormater;
        static NSDateFormatter *dateFormaterFromString;
        if (!dateFormater) {
            dateFormater = [[NSDateFormatter alloc] init];
            dateFormater.dateFormat = @"yyyy.MM.dd HH:mm";
            
            dateFormaterFromString = [[NSDateFormatter alloc] init];
            dateFormaterFromString.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
        NSDate *createTime = [dateFormaterFromString dateFromString:knowledgeTime];
        self.time  = [dateFormater stringFromDate:createTime];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Knowledge *new = [[Knowledge allocWithZone:zone] init];
    new.id = self.id;
    new.title = self.title;
    new.time = self.time;
    new.content = self.content;
    
    return new;
}
@end
