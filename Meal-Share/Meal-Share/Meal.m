//
//  Meal.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/20/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "Meal.h"


#define safeSet(d,k,v) if (v) d[k] = v;

@implementation Meal
//- (instancetype) init
//{
//    self = [super init];
//    if (self) {
//        _categories = [NSMutableArray array];
//    }
//    return self;
//}

#pragma mark - serialization

- (instancetype) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];

    if (self) {
    NSLog(@"dictionary: %@",dictionary[@"title"]);
        _mealTitle = dictionary[@"title"];
        _mealSeller = dictionary[@"seller"];
        _mealAvailableSpots = dictionary[@"availableSpots"];
        _mealStartDateTime = dictionary[@"startDateTime"];
        _mealEndDateTime = dictionary[@"endDateTime"];
        _mealAddress = dictionary[@"mealAddress"];
        _mealDescription = dictionary[@"description"];
        _mealId = dictionary[@"_id"];
        _imagePath = dictionary[@"imagePath"];
        _imageID = dictionary[@"imageID"];
        _price = dictionary[@"price"];

        _mealEatHere = dictionary[@"isEatHere"];
        _mealToGo    = dictionary[@"isToGo"];
        _mealVegan   = dictionary[@"isVegan"];
        _mealGlutenFree = dictionary[@"isGlutenFree"];
        _mealVegetarian = dictionary[@"isVegetarian"];
      
        NSLog(@"in the parse dictionary");
      //  _categories = [NSMutableArray arrayWithArray:dictionary[@"categories"]];
    }
    return self;
}

- (NSDictionary*) toDictionary
{



    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"title", self.mealTitle);
    safeSet(jsonable, @"seller", self.mealSeller);
    safeSet(jsonable, @"availableSpots", self.mealAvailableSpots);
    safeSet(jsonable, @"startDateTime", self.mealStartDateTime);
    safeSet(jsonable, @"endDateTime", self.mealEndDateTime);
    safeSet(jsonable, @"mealAddress", self.mealAddress);
    safeSet(jsonable, @"description", self.mealDescription);
   // safeSet(jsonable, @"_id", self.mealId);
    safeSet(jsonable, @"imagePath", self.imagePath);
        safeSet(jsonable, @"price", self.price);
    
    safeSet(jsonable, @"isEatHere", self.mealEatHere);
    safeSet(jsonable, @"isToGo", self.mealToGo);
    safeSet(jsonable, @"isVegan", self.mealVegan);
    safeSet(jsonable, @"isGlutenFree", self.mealGlutenFree);
    safeSet(jsonable, @"isVegetarian", self.mealVegetarian);

    

    return jsonable;
}




@end
