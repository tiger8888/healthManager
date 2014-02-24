//
//  InputCodeViewController.m
//  HealthManager
//
//  Created by user on 14-2-20.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "InputCodeViewController.h"
#import "ScanCodeViewController.h"
#import "CodeInformationViewController.h"

@interface InputCodeViewController ()

@end

@implementation InputCodeViewController

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
    [self.codeText becomeFirstResponder];
    self.codeText.text = @"81290090508502782164";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSubmit:(id)sender {
    if ( [[Message sharedManager] checkMedicinalCode:self.codeText.text] ) {
        CodeInformationViewController *codeInfoCtl = [[CodeInformationViewController alloc] initWithCategory:20];
        codeInfoCtl.codeStr = self.codeText.text;
        [self.navigationController pushViewController:codeInfoCtl animated:YES];
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
