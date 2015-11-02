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
        _mealDescription = dictionary[@"foodItems"];
        _mealId = dictionary[@"_id"];
        _imageId = dictionary[@"imageId"];
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
    safeSet(jsonable, @"foodItems", self.mealDescription);
    safeSet(jsonable, @"_id", self.mealId);
//
//    NSData* data = UIImagePNGRepresentation(self.image);
//    NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"cameraButton" ofType:@"png"];

    safeSet(jsonable, @"imageId", self.imageId);
   // safeSet(jsonable, @"categories", self.categories);

    return jsonable;
}


@end
