//
//  PPCheckBox.h
//  HealthManager
//
//  Created by user on 14-3-6.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPCheckBoxDelegate;

@interface PPCheckBox : UIButton
@property(nonatomic, assign)id<PPCheckBoxDelegate> delegate;
@property(nonatomic, assign)BOOL checked;


- (id)initWithDelegate:(id)delegate normalImage:(UIImage *)normalImg selectedImage:(UIImage *)selectedImg;
@end

@protocol PPCheckBoxDelegate <NSObject>

@optional
- (void)didSelectedCheckBox:(PPCheckBox *)checkBox checked:(BOOL)checked;

@end