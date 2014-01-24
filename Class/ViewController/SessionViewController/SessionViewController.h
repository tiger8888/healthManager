//
//  SessionViewController.h
//  HealthManager
//
//  Created by 李硕 on 2014/01/15.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionMessage.h"

@interface SessionViewController : BackButtonViewController<UITextFieldDelegate>
{
    NSArray *_styleArray;
    SessionMessage *_sessionMessage;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)submitOkClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end
