//
//  Meals.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/20/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Meal;

@protocol MealModelDelegate <NSObject>

-(void) modelUpdated;

@end

@interface Meals : NSObject
@property (nonatomic, strong) NSMutableArray* objects;
@property (nonatomic, weak) id<MealModelDelegate> delegate;
-(void) import;
-(void) persist:(Meal*)meals;
@end
