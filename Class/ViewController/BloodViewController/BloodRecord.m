//
//  BloodRecord.m
//  HealthManager
//
//  Created by LiShuo on 13-12-7.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "BloodRecord.h"

@implementation BloodRecord

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _highPressure = [[LSTextField alloc] initWithFrame:CGRectMake(119, 52, 173, 36) andBackgroundImage:@"blood_texfield" andEditingBackgroundImage:@"blood_texfield_selected"];
    _highPressure.retract = 5;
    _highPressure.textField.placeholder = @"请输入数值";
    [self addSubview:_highPressure];
    
    _lowPressure = [[LSTextField alloc] initWithFrame:CGRectMake(119, 118, 173, 36) andBackgroundImage:@"blood_texfield" andEditingBackgroundImage:@"blood_texfield_selected"];
    _lowPressure.retract = 5;
    _lowPressure.textField.placeholder = @"请输入数值";
    [self addSubview:_lowPressure];
    
    _pulse = [[LSTextField alloc] initWithFrame:CGRectMake(119, 187, 173, 36) andBackgroundImage:@"blood_texfield" andEditingBackgroundImage:@"blood_texfield_selected"];
    _pulse.retract = 5;
    _pulse.textField.placeholder = @"请输入数值";
    [self addSubview:_pulse];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void)setSaveBlock:(void (^)(NSString *, NSString *, NSString *))saveBlock
{
    _saveBlock = saveBlock;
}

- (IBAction)saveBTBClick:(id)sender
{
    NSLog(@"save");
    if (_saveBlock)
    {
        _saveBlock(_highPressure.textField.text,_lowPressure.textField.text,_pulse.textField.text);
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.highPressure.textField resignFirstResponder];
    [self.lowPressure.textField resignFirstResponder];
    [self.pulse.textField resignFirstResponder];
}
@end
