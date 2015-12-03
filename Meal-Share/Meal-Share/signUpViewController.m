//
//  signUpViewController.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/17/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "signUpViewController.h"
#import "Person.h"


static NSString* const mSignURL = @"http://172.16.0.15:8080/api/persons";
@interface signUpViewController ()

@property (strong, nonatomic) Person *person;
@end

@implementation signUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    [self addPerson];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) addPerson
{
    if (!self.person) {
        self.person = [[Person alloc] init];
    }
    
    self.person.firstName = self.firstNameTextField.text;
    self.person.lastName = self.lastNameTextField.text;
    self.person.email = self.emailTextField.text;
    self.person.password = self.passwordTextField.text;
    
    if (self.person.firstName == nil || self.person.lastName == nil || self.person.email ==nil || self.person.password == nil ||self.person.firstName.length == 0 || self.person.lastName.length == 0 || self.person.email.length == 0 || self.person.password.length == 0) {
        return; //input safety check
    }
   
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURL* url = [NSURL URLWithString:mSignURL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:[self.person toDictionary] options:0 error:NULL];
    request.HTTPBody = data;
    
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (!error) {
                        
                        NSLog(@"Response: %@", response);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            // Back on the main thread, ask the tableview to reload itself.
                            [self performSegueWithIdentifier:@"toLogin" sender:nil];
                            
                        });
                        
                    }
                    else
                    {
                        NSLog(@"error");
                    }
                }] resume];

    
}


@end
