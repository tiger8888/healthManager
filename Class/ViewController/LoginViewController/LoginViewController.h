//
//  LoginViewController.h
//  HealthManager
//
//  Created by LiShuo on 13-11-29.
//
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>

- (void)loginComplate;

@end

@interface LoginViewController : RootSuperViewController

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) id<LoginDelegate> delegate;

- (IBAction)onClick:(id)sender;

@end
