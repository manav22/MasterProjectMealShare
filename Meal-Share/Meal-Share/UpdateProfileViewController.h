//
//  UpdateProfileViewController.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 11/19/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *creditCardNumTextField;

- (IBAction)editNameButtonPressed:(UIButton *)sender;
- (IBAction)editLastNameButtonPressed:(UIButton *)sender;
- (IBAction)editDateOfBirthButtonPressed:(UIButton *)sender;


- (IBAction)editAddressButtonPressed:(UIButton *)sender;
- (IBAction)updateCardButtonPressed:(UIButton *)sender;

- (IBAction)photoButtonPressed:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@end
