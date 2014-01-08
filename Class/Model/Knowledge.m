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

- (void)readFromJSONDictionary:(NSDictionary *)data {
    self.title = [data objectForKey:@"title"];
    self.id = (int)[data objectForKey:@"id"];
    self.content = [data objectForKey:@"content"];
}
@end
