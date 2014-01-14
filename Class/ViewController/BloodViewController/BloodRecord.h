//
//  BloodRecord.h
//  HealthManager
//
//  Created by LiShuo on 13-12-7.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTextField.h"

typedef void(^SaveBlock)(NSString *,NSString *,NSString *);
@interface BloodRecord : UIView
{
    SaveBlock _saveBlock;
}
@property (strong, nonatomic) LSTextField *highPressure;
@property (strong, nonatomic) LSTextField *lowPressure;
@property (strong, nonatomic) LSTextField *pulse;

- (void)setSaveBlock:(void(^)(NSString *highPressure,NSString *lowPressure,NSString *pulse))saveBlock;

- (IBAction)saveBTBClick:(id)sender;

@end