//
//  PostCuisineViewController.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/21/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCuisineViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *mealTitleTextField;
@property (strong, nonatomic) IBOutlet UITextField *mealAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberOfPersonsTextField;
@property (strong, nonatomic) IBOutlet UITextView *mealDescriptionTextView;

@property (strong, nonatomic) IBOutlet UIImageView *cuisineImage;
- (IBAction)cameraButtonPressed:(UIButton *)sender;

- (IBAction)vegetarianSwitch:(UISwitch *)sender;
- (IBAction)eatHereSwitch:(UISwitch *)sender;
- (IBAction)postBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)togoSwitch:(UISwitch *)sender;

@property (strong, nonatomic) IBOutlet UIDatePicker *availableUntilDatePicker;

@end
