//
//  HttpRequestManager.m
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "HttpRequestManager.h"

@interface HttpRequestManager ()
{
    NSMutableData *_tmpData;
}
@end

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
        _tmpData = [[NSMutableData alloc] init];
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

- (void)requestLoginWithData:(NSData *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[BASEURL stringByAppendingPathComponent:@"/login.json"]]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_tmpData resetBytesInRange:NSMakeRange(0, _tmpData.length)];
    [_tmpData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_tmpData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *str = [[NSString alloc] initWithData:_tmpData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
}
@end
