//
//  LSTextField.h
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnKeyClickedBlock)(UITextField *textField);

@interface LSTextField : UIView <UITextFieldDelegate>
{
@private
    UIImageView *_background;
    ReturnKeyClickedBlock _returnClickedBlock;
}
@property (nonatomic, assign) CGFloat retract;
@property (nonatomic, retain) UITextField *textField;;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) UIImage *editBackgroundImage;


- (id)initWithFrame:(CGRect)frame andBackgroundImage:(NSString *)backgroundImageName andEditingBackgroundImage:(NSString *)editBackgroundImageName;
- (void)setReturnKeyClickedBlock:(void(^)(UITextField *textField))returnKeyClickedBlock;
@end
