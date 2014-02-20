//
//  ScanCodeViewController.h
//  HealthManager
//
//  Created by user on 14-2-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ScanCodeViewController : BackButtonViewController<ZBarReaderViewDelegate>
{
    ZBarCameraSimulator *cameraSim;
}
- (IBAction)inputCodeClick:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomPlaceView;
@property (nonatomic, retain) IBOutlet ZBarReaderView *readerView;
@end
