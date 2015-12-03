//
//  LoginViewController.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/14/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "LoginViewController.h"

static NSString* const mLoginURL = @"http://mealshare-aslimaye90.c9users.io/api/login";

@interface LoginViewController ()
@property(nonatomic)long statusCode;




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

    //    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.ios.StoryBoards.Meal-Share" accessGroup:nil];
//    
//    [keychainItem setObject:@"password you are saving" forKey:(__bridge id)(kSecValueData)];
//    [keychainItem setObject:@"username you are saving" forKey:(__bridge id)(kSecAttrAccount)];
    
    

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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURL *url = [NSURL URLWithString:mLoginURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:self.emailTextField.text forKey:@"email"];
    [parameters setObject:self.passwordTextField.text forKey:@"password"];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login Successful"
//                                                        object:nil
//                                                      userInfo:parameters];
    
   // NSLog(@"parameters: %@", parameters);
    NSData* data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];
    request.HTTPBody = data;
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                    if (!error) {
                        
                        
                        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                             long statusCode = (long)[(NSHTTPURLResponse *)response statusCode];
                            self.statusCode = statusCode;
                            if (statusCode != 200) {
                                // for example, 404 would mean that your web site said it couldn't find the URL
                                // anything besides 200 means that there was some fundamental web server error
                                
                                NSLog(@"request resulted in statusCode of %ld", statusCode);
                                NSLog(@"Response %@", response);
                                return;
                            }
                            else
                            {
//                            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                            NSLog(@"Response string: %@", responseString);
                                
                                NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                                [self saveTokens:responseDictionary];
                                
                                
                          //      NSDictionary *tokenDic = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
                            //    NSLog(@"token dictionary is here: %@", tokenDic);
                                
                            NSLog(@"Response:   %@", response);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    // Back on the main thread, ask the tableview to reload itself.
                                    [self loginSuccessful];
                                    
                                });
                            
                            }
                            //                            [self loginSuccessful];
//                            if ([responseString rangeOfString:@"Welcome"] != NSNotFound) {
//                                loginPageStatusLabel.text = @"Correct";
//                                NSLog(@"Correct Login");
//                                
//                                [self performSegueWithIdentifier:@"toHome" sender:self];
//                            } else {
//                                loginPageStatusLabel.text = @"Incorrect";
//                                NSLog(@"Login Failed");
//                            }

                        
                        //[self parseAndAddLocations:responseArray toArray:self.objects];
                    }
                    }
                    else
                    {
                        if (!data) {
                            // for example, no internet connection or your web server is down
                            
                            NSLog(@"request failed: %@", error);
                            return;
                        }
                        NSLog(@"Login error");
                    }
                    }] resume];
   
   
}

-(void)loginSuccessful
{
        [self performSegueWithIdentifier:@"toHomePage" sender:nil];
    
}

-(void)saveTokens:(NSDictionary *)responseDictionary
{
        
    NSLog(@"here comes the dictionary: %@", responseDictionary);
    
    
     self.keyChainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.ios.StoryBoards.Meal-Share" accessGroup:nil];
    
    [self.keyChainItem setObject:responseDictionary[@"token"] forKey:(__bridge id)(kSecValueData)];
    [self.keyChainItem setObject:responseDictionary[@"isCreditCard"] forKey:(__bridge id)(kSecAttrIsInvisible)];
    NSLog(@"token: %@", [self getToken]);

    
}

-(NSString *)getToken
{
    
    return [self.keyChainItem objectForKey:(__bridge id)(kSecValueData)];
    
}
-(NSString *)ccFlag
{
    return [self.keyChainItem objectForKey:(__bridge id)(kSecAttrIsInvisible)];
}

@end
