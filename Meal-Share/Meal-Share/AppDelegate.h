//
//  AppDelegate.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/14/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Meals.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Meals *meals; //Singleton Data Model

+(AppDelegate*) appDelegate; //Helper to get static instance

@end

