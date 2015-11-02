//
//  LoginViewController.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/14/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     self.loginButton = [[FBSDKLoginButton alloc] init];
//    
//    self.loginButton.frame = CGRectMake(20, 20, 20, 20);
//    self.loginButton.delegate = self;
//    [self.view addSubview:self.loginButton];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)signUpBarButtonItemPressed:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:^() {
        [self performSegueWithIdentifier:@"toSignUpViewController" sender:self];
    }];
    NSLog(@"signUp");

}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
}

@end
