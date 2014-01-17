//
//  HttpRequestManager.h
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface HttpRequestManager : NSObject <NSURLConnectionDelegate>

typedef enum
{
    kGet = 1,
    kPost
} requestMethod;

typedef void (^LSDataBlock)(NSData *data);
typedef void (^LSJSONBlock)(id returnObject);
typedef void (^LSVoidBlock)();

+ (HttpRequestManager *)sharedManager;

- (void)requestWithParameters:(NSDictionary *)parameters interface:(NSString *)interface completionHandle:(LSJSONBlock)block failed:(void(^)(void))failedBlock hitSuperView:(UIView *)superView method:(requestMethod)method;
- (void)requestLoginWithData:(NSData *)data completionHandle:(LSJSONBlock)block failed:(void(^)(void))failedBlock hitSuperView:(UIView *)superView;
@end
