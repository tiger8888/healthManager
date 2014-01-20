//
//  Knowledge.m
//  HealthManager
//
//  Created by user on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "Knowledge.h"

@implementation Knowledge
@synthesize id, title, content;

- (id)init
{
    return [self initWithId:0 withTitle:@"" withContent:@""];
}

- (id)initWithId:(int)knowledgeId withTitle:(NSString *)knowledgeTitle withContent:(NSString *)knowledgeContent {
    self = [super init];
    if (self) {
        self.id = knowledgeId;
        self.title = knowledgeTitle;
        self.content = knowledgeContent;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Knowledge *new = [[Knowledge allocWithZone:zone] init];
    new.id = self.id;
    new.title = self.title;
    new.content = self.content;
    
    return new;
}
@end
