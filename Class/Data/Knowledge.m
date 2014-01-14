//
//  Knowledge.m
//  HealthManager
//
//  Created by user on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "Knowledge.h"

@implementation Knowledge
@synthesize id, title, content, url;

- (void)readFromJSONDictionary:(NSDictionary *)data {
    self.title = [data objectForKey:@"title"];
    if ( [data objectForKey:@"id"] )
        self.id = (int)[data objectForKey:@"id"];
    if ( [data objectForKey:@"content"] )
        self.content = [data objectForKey:@"content"];
    if ( [data objectForKey:@"url"] )
        self.url = [data objectForKey:@"url"];
}
@end
