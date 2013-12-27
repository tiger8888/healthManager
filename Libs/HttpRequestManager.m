//
//  HttpRequestManager.m
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "HttpRequestManager.h"


static HttpRequestManager *_sharedManager;

@implementation HttpRequestManager

+ (HttpRequestManager *)sharedManager
{
    @synchronized(self)
    {
        if (_sharedManager == nil)
        {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedManager == nil)
        {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)requestWithParameters:(NSDictionary *)parameters interface:(NSString *)interface completionHandle:(LSJSONBlock)block
{
//    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] init];
//    []
#warning implementation
}
@end
