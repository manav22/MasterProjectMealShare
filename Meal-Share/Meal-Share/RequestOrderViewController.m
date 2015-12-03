//
//  RequestOrderViewController.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/25/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "RequestOrderViewController.h"

@interface RequestOrderViewController ()

@end

@implementation RequestOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
    self.mealTitleLabel.text = self.selectedMeal.mealTitle;
    self.mealAddresslabel.text = self.selectedMeal.mealAddress;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@", self.selectedMeal.price];
    self.numberOfPersonsLabel.text = [NSString stringWithFormat:@"%@",self.selectedMeal.mealAvailableSpots];
    self.mealDescriptionLabel.text = self.selectedMeal.mealDescription;
    self.mealEndDateLabel.text = [NSString stringWithFormat:@"%@",self.selectedMeal.mealEndDateTime];
    self.cuisineImageView.image = self.selectedMeal.mealImage;
    
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

@end
