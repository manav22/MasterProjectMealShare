//
//  Meals.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/20/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "Meals.h"
#import "Meal.h"
static NSString* const mBaseURL = @"http://localhost:8000/";
static NSString* const mMeals = @"api/meals";

@interface Meals ()

@end

@implementation Meals

- (id)init
{
    self = [super init];
    if (self) {
        _objects = [NSMutableArray array];
    }
    return self;
}

- (void)import
{
    NSURL* url = [NSURL URLWithString:[mBaseURL stringByAppendingPathComponent:mMeals]]; //1
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET"; //2
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"]; //3
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //4
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
            NSLog(@"%@",responseArray);
            [self parseAndAddMeals:responseArray toArray:self.objects]; //7
        }
    }];
    
    [dataTask resume]; //8
    
}

- (void)parseAndAddMeals:(NSArray*)meals toArray:(NSMutableArray*)destinationArray //1
{
    for (NSDictionary* item in meals) {

        Meal *meal = [[Meal alloc] initWithDictionary:item]; //2
        NSLog(@"meal: %@", meal.mealTitle);
        [destinationArray addObject:meal];
        NSLog(@"Objects: %@", destinationArray[0]);
        if (meal.imageId) { //1
            [self loadImage:meal];
        }
    }
    
    if (self.delegate) {
        [self.delegate modelUpdated]; //3
    }
    
}

- (void) persist:(Meal*)meal
{
    if (!meal || meal.mealTitle == nil || meal.mealTitle.length == 0) {
        return; //input safety check
    }
    
    //if there is an image, save it first
//    if (meal.image != nil && meal.imageId == nil) { //1
//        [self saveNewMealImageFirst:meal]; //2
//        return;
//    }
    
    NSString* meals = [mBaseURL stringByAppendingPathComponent:mMeals];
    
//    BOOL isExistingMeal = meal.mealId != nil;
//    NSURL* url = isExistingMeal ? [NSURL URLWithString:[meals stringByAppendingPathComponent:meal.mealId]] :
//    [NSURL URLWithString:meals]; //1
//    
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = isExistingMeal ? @"PUT" : @"POST"; //2
    
    NSURL* url = [NSURL URLWithString:meals];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:[meal toDictionary] options:0 error:NULL]; //3
    
    
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //4
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (!error) {
            NSArray* responseArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
            [self parseAndAddMeals:responseArray toArray:self.objects];
        }
    }];
    [dataTask resume];
}

- (void) saveNewMealImageFirst:(Meal*)meal
{
    NSURL* url = [NSURL URLWithString:[mBaseURL stringByAppendingPathComponent:mMeals]]; //1
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST"; //2
    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"]; //3
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSData* bytes = UIImagePNGRepresentation(meal.image); //4
    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromData:bytes completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil && [(NSHTTPURLResponse*)response statusCode] < 300) {
            NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            meal.imageId = responseDict[@"_id"]; //6
            [self persist:meal]; //7
        }
    }];
    [task resume];
}

- (void)loadImage:(Meal*)meal
{
    NSURL* url = [NSURL URLWithString:[[mBaseURL stringByAppendingPathComponent:mMeals] stringByAppendingPathComponent:meal.imageId]]; //1
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDownloadTask* task = [session downloadTaskWithURL:url completionHandler:^(NSURL *fileLocation, NSURLResponse *response, NSError *error) { //2
        if (!error) {
            NSData* imageData = [NSData dataWithContentsOfURL:fileLocation]; //3
            UIImage* image = [UIImage imageWithData:imageData];
            if (!image) {
                NSLog(@"unable to build image");
            }
            meal.image = image;
            if (self.delegate) {
                [self.delegate modelUpdated];
            }
        }
    }];
    
    [task resume]; //4
}
@end
