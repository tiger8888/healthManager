//
//  LoginViewController.h
//  HealthManager
//
//  Created by LiShuo on 13-11-29.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : RootSuperViewController

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)onClick:(id)sender;

@end
