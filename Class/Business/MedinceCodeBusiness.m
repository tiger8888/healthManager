//
//  MedinceCodeBusiness.m
//  HealthManager
//
//  Created by user on 14-2-24.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "MedinceCodeBusiness.h"
#import "MedinceCode.h"

static MedinceCodeBusiness *_sharedManager;

@implementation MedinceCodeBusiness
+ (MedinceCodeBusiness *)sharedManager
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

- (void)request:(NSString *)codeStr completionHandle:(ObjectBlock)block failed:(void(^)(void))failedBlock hitSuperView:(UIView *)superView requestMethod:(requestMethod)method;
{
    codeStr = @"81143850055271863898";
    NSString *systemId = @"piats-mobile";//@"chronic";//@"piats-mobile";
    NSString *interfaceUrl = @"http://sp.drugadmin.com/ivr/code/codeQuery.jhtml?phone=13121993214&code=%@&searchthrough=6&fromChannel=1&systemId=%@";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:interfaceUrl, codeStr ,systemId ]]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    switch (method) {
        case kPost:
            [request setHTTPMethod:@"POST"];
            
            break;
        case kGet:
            [request setHTTPMethod:@"GET"];
            break;
        default:
            break;
    }
    [request setHTTPBody:nil];
    
    _completeBlock = block;
    _failedBlock = failedBlock;
    _superView = superView;
    
    if (superView) {
        [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
//    NSData *reeived = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"data is :%@",reeived);
//    block(reeived);
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [MBProgressHUD hideHUDForView:_superView animated:YES];
    if (_failedBlock) {
        _failedBlock();
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:_superView animated:YES];
//    NSString *webcontent = [[NSString alloc] initWithData:_tmpData encoding:NSUTF8StringEncoding];
//    NSLog(@"data is %@", webcontent);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_tmpData];
    MedinceCode *medinceCode = [MedinceCode new];
    [parser setDelegate:medinceCode];
    [parser parse];
    if (_completeBlock) {
        _completeBlock(medinceCode);
    }
}
@end
