//
//  Meal.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/20/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meal : NSObject

@property (nonatomic, strong) NSString* mealTitle;
@property (nonatomic, strong) NSString* mealSeller;
@property (nonatomic, strong) NSString* mealAvailableSpots;
@property (nonatomic, strong) NSString* mealStartDateTime;
@property (nonatomic, strong) NSString* mealEndDateTime;
@property (nonatomic, strong) NSString* mealAddress;
@property (nonatomic, strong) NSString* mealDescription;
@property (nonatomic, strong) NSString* mealId;
@property (nonatomic, strong) NSString* imagePath;

@property (nonatomic, strong) NSString* price;
//@property (nonatomic, retain, readonly) NSMutableArray* categories;

/** This property starts out YES until modified manually or loaded from the network. This way dragging the pin will update the coordinates and geocoded info */
//@property (nonatomic) BOOL configuredBySystem;
////

@property (nonatomic, strong) NSString* imageID;

@property (nonatomic, strong) UIImage* mealImage;

@property (nonatomic, strong) NSString* mealVegan;
@property (nonatomic, strong) NSString* mealVegetarian;
@property (nonatomic, strong) NSString* mealGlutenFree;

@property (nonatomic, strong) NSString* mealEatHere;
@property (nonatomic, strong) NSString* mealToGo;
@property (nonatomic, strong) NSString* mealDelivery;

@property (nonatomic, strong) NSString* token;
#pragma mark - JSON-ification

- (instancetype) initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) toDictionary;

//#pragma mark - Location
//
//- (void) setLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
//- (void) setGeoJSON:(id)geoPoint;
//- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
