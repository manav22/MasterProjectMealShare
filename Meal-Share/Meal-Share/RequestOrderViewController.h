//
//  RequestOrderViewController.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/25/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"
@interface RequestOrderViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *mealTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *mealAddresslabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfPersonsLabel;
@property (strong, nonatomic) IBOutlet UILabel *mealDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *mealEndDateLabel;

@property (strong, nonatomic) Meal *selectedMeal;
@end
