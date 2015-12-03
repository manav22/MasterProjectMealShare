//
//  Meals.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/20/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "Meals.h"
#import "Meal.h"
#import "PostCuisineViewController.h"
#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
#import <AFNetworking/AFNetworking.h>
static NSString* const mBaseURL = @"http://mealshare-aslimaye90.c9users.io";
static NSString* const mMeals = @"/api/meals";
static NSString* const mMealImage =@"/getimage";

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
            NSLog(@"Response : %@",responseArray);
            [self parseAndAddMeals:responseArray toArray:self.objects]; //7
        }
        else{
            NSLog(@"Error: %@",response);
        }
    }];
    
    [dataTask resume]; //8
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"http:/172.16.0.5:8080/getimage" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:@"http:/172.16.0.5:8080/getimage"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"Response: %@ %@", response, responseObject);
//        }
//    }];
//    [dataTask resume];
    
}

- (void)parseAndAddMeals:(NSArray*)meals toArray:(NSMutableArray*)destinationArray //1
{
    for (NSDictionary* item in meals) {

        Meal *meal = [[Meal alloc] initWithDictionary:item]; //2
        NSLog(@"meal: %@", meal.mealTitle);
        [destinationArray addObject:meal];
        NSLog(@"Objects: %@", destinationArray[0]);
        if (meal.imageID) { //1
            NSLog(@"meal.image: %@", meal.imageID );
            [self loadImage:meal.imageID andMeal:meal];
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
    
//    NSURL* url = [NSURL URLWithString:meals];
//
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
    NSLog(@"%@", meals);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
     KeychainItemWrapper* keyChainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.ios.StoryBoards.Meal-Share" accessGroup:nil];
        NSData *tokenData = [keyChainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *token = [[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding];
    NSLog(@"Meals class: %@", token);
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"bearer"];
    
  
    NSDictionary *parameters = [meal toDictionary];
    NSLog(@"%@",[parameters objectForKey:@"imagePath"]);
    NSURL *filePath = [NSURL fileURLWithPath:[parameters objectForKey:@"imagePath"]];
    [manager POST:meals parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        NSLog(@"Dictionary: %@", parameters);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}

//- (void) saveNewMealImageFirst:(Meal*)meal
//{
//    NSURL* url = [NSURL URLWithString:[mBaseURL stringByAppendingPathComponent:mMeals]]; //1
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST"; //2
//    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"]; //3
//    
//    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
//    
//    NSData* bytes = UIImagePNGRepresentation(meal.image); //4
//    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromData:bytes completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
//        if (error == nil && [(NSHTTPURLResponse*)response statusCode] < 300) {
//            NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            meal.imageId = responseDict[@"_id"]; //6
//            [self persist:meal]; //7
//        }
//    }];
//    [task resume];
//}

- (void)loadImage:(NSString*)imageId andMeal:(Meal*)meal
{
    NSString* image = [mBaseURL stringByAppendingPathComponent:mMealImage];
   
    NSURL* url = [NSURL URLWithString:[image stringByAppendingPathComponent:imageId]]; //1
     NSLog(@"url: %@",url);
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDownloadTask* task = [session downloadTaskWithURL:url completionHandler:^(NSURL *fileLocation, NSURLResponse *response, NSError *error) { //2
        if (!error) {
            NSData* imageData = [NSData dataWithContentsOfURL:fileLocation]; //3
            UIImage* image = [UIImage imageWithData:imageData];
            if (!image) {
                NSLog(@"unable to build image");
            }
            else
            {
                
                meal.mealImage = image;
                NSLog(@"mealImage:%@",meal.mealImage);
                
            }
            NSLog(@"image is here %@", image);
            
            
            if (self.delegate) {
                [self.delegate modelUpdated];
            }
        }
    }];
    
    [task resume]; //4
}
@end
