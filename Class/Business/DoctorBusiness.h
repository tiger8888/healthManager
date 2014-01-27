//
//  DoctorBusiness.h
//  HealthManager
//
//  Created by user on 14-1-27.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SessionMessage;

@interface DoctorBusiness : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *_tmpData;
    //登陆界面专用成员变量
    LSDataBlock _completeBlock;
    LSVoidBlock _failedBlock;
}
+ (DoctorBusiness *)sharedManager;

- (void)getAllDoctor:(void(^)(NSArray *arr))block superView:(UIView *)superView;
- (void)setMyDoctorInfo;
- (void)setMyDoctorInfoSync;
- (void)addMyDoctor:(id)obj;
- (void)deleteMyDoctor;

- (void)getMyDoctorSessionInfo:(void(^)(SessionMessage* msg))block withSuperView:(UIView *)superView;
- (NSArray *)getMyDoctorAllSessionInfo;
- (void)sendSessionMessageToMydoctor:(SessionMessage *)msg withBlock:(void(^)(void))block superView:(UIView *)superView;
@end
