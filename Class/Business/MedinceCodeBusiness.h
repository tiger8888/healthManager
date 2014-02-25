//
//  MedinceCodeBusiness.h
//  HealthManager
//
//  Created by user on 14-2-24.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MedinceCode;

typedef void (^ObjectBlock)(MedinceCode *obj);

@interface MedinceCodeBusiness : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *_tmpData;
    UIView *_superView;
    ObjectBlock _completeBlock;
    LSVoidBlock _failedBlock;
}
+ (MedinceCodeBusiness *)sharedManager;
- (void)request:(NSString *)codeStr completionHandle:(ObjectBlock)block failed:(void(^)(void))failedBlock hitSuperView:(UIView *)superView requestMethod:(requestMethod)method;
@end
