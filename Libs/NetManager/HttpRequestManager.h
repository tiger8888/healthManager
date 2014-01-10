//
//  HttpRequestManager.h
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface HttpRequestManager : NSObject

typedef void (^LSDataBlock)(NSData *data);
typedef void (^LSJSONBlock)(NSDictionary *jsonObject);

+ (HttpRequestManager *)sharedManager;

- (void)requestWithParameters:(NSDictionary *)parameters interface:(NSString *)interface completionHandle:(LSJSONBlock)block;


@end
