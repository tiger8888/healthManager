//
//  FeedbackViewController.h
//  HealthManager
//
//  Created by PanPeng on 14-1-22.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : BackButtonViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)submitOnClick:(id)sender;

@end
