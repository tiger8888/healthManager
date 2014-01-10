//
//  LSTextField.m
//  HealthManager
//
//  Created by 李硕 on 13-12-27.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "LSTextField.h"

@implementation LSTextField

- (id)initWithFrame:(CGRect)frame andBackgroundImage:(NSString *)backgroundImageName andEditingBackgroundImage:(NSString *)editBackgroundImageName
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = frame;
        
        
        UIImage *backgroundImage = [UIImage imageNamed:backgroundImageName];
        self.backgroundImage = backgroundImage;
        
        UIImage *editBackgroundImage = [UIImage imageNamed:editBackgroundImageName];
        self.editBackgroundImage = editBackgroundImage;
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_background];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.retract, 0, frame.size.width -self.retract, frame.size.height)];
        _textField.delegate = self;
        [self addSubview:_textField];
        
        NSLog(@"%d",[self.subviews count]);
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _textField.frame = CGRectMake(self.retract, 0, frame.size.width -self.retract, frame.size.height);
}

- (void)setRetract:(CGFloat)retract
{
    _retract = retract;
    [self setFrame:self.frame];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (backgroundImage)
    {
        _backgroundImage = backgroundImage;
        _background.image = _backgroundImage;
    }
}

- (void)setReturnKeyClickedBlock:(void(^)(UITextField *textField))returnKeyClickedBlock
{
    _returnClickedBlock = returnKeyClickedBlock;
}
#pragma mark - TextFieldDelegate Method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_editBackgroundImage)
    {
        _background.image = _editBackgroundImage;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_backgroundImage)
    {
        _background.image = _backgroundImage;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (_returnClickedBlock) {
        _returnClickedBlock(textField);
    }
    return YES;
}
@end
