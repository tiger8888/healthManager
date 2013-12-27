//
//  BloodViewController.h
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "RootSuperViewController.h"
#import "LSSegment.h"
@interface BloodViewController : SuperListViewController <LSSegmentDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *highPressure;
@property (strong, nonatomic) IBOutlet UITextField *lowPressure;
@property (strong, nonatomic) IBOutlet UITextField *pulse;
- (IBAction)saveBTBClick:(id)sender;

@end
