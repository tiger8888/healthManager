//
//  DoctorModel.h
//  HealthManager
//
//  Created by 李硕 on 13-12-19.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *detail;

@property (nonatomic, assign) CGFloat height;


@end
