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

- (void)requestWithParameters:(NSDictionary *)parameters interface:(NSString *)interface completionHandle:(LSJSONBlock)block failed:(void(^)(void))failedBlock hitSuperView:(UIView *)superView method:(requestMethod)method
{
    [MBProgressHUD showHUDAddedTo:superView animated:YES];

    AFHTTPClient *requestOperation = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [requestOperation setParameterEncoding:AFJSONParameterEncoding];
    
    switch (method) {
        case kGet:
        {
            [requestOperation getPath:interface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [MBProgressHUD hideHUDForView:superView animated:YES];
                block(responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [MBProgressHUD hideHUDForView:superView animated:YES];
                failedBlock();
                
            }];
        }
            break;
        case kPost:
        {
            [requestOperation postPath:interface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
                
                [MBProgressHUD hideHUDForView:superView animated:YES];
                block(responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [MBProgressHUD hideHUDForView:superView animated:YES];
                failedBlock();
                
            }];
        }
            break;
        default:
            break;
    }
}
@end
