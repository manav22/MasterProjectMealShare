//
//  LoginViewController.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/14/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
//@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)signUpBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
