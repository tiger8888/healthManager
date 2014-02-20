//
//  ScanCodeViewController.m
//  HealthManager
//
//  Created by user on 14-2-13.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "ScanCodeViewController.h"
#import "ScanCodeMaskView.h"
#import "InputCodeViewController.h"
#import "CodeInformationViewController.h"

@interface ScanCodeViewController ()
    

@end

@implementation ScanCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showScanView];
    [self showMask];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showMask {
    self.bottomPlaceView.frame = CGRectMake(0, DEVICE_HEIGHT-40, DEVICE_WIDTH, 44);
    ScanCodeMaskView *maskView = [[ScanCodeMaskView alloc] initWithFrame:CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT - 44-44-20)];
    [self.view addSubview:maskView];
}

- (void)showScanView {
//    请将条形码置于扫描框的红线内，避免反光或阴影
//    提示：【中国药品电子监管码】一般位于药盒的背面或侧面
    [ZBarReaderView class];
    self.readerView.readerDelegate = self;
    self.readerView.frame = CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT-88);
    
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc] initWithViewController:self];
        cameraSim.readerView = self.readerView;
    }

//    ZBarReaderController *readerCtl = [ZBarReaderController new];
//    readerCtl.readerDelegate = self;
//    ZBarImageScanner *scanner = readerCtl.scanner;
//    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
//    
//    [self presentModalViewController:readerCtl animated:YES];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    NSLog(@"info=%@", info);
//    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for (symbol in results) {
//        break;
//    }
//    
//    NSLog(@"code text = %@", symbol.data);
//    
//}
- (void) viewDidAppear: (BOOL) animated
{
    // run the reader when the view is visible
    [self.readerView start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [self.readerView stop];
}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    NSString *codeStr;
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"code text = %@", symbol.data);
        codeStr = symbol.data;
        break;
    }
    
    CodeInformationViewController *codeInfoCtl = [[CodeInformationViewController alloc] initWithCategory:20];
    codeInfoCtl.codeStr = codeStr;
    [self.navigationController pushViewController:codeInfoCtl animated:YES];
    
}
- (IBAction)inputCodeClick:(id)sender {
    InputCodeViewController *inputCodeCtl = [[InputCodeViewController alloc] initWithCategory:19];
    [self.navigationController pushViewController:inputCodeCtl animated:YES];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIColor *)colorWithRGB:(int)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.5];
}
@end
