//
//  Person.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 11/12/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

//required as buyer
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;

//optional (if seller)
@property (nonatomic, strong) NSString* creditCardNumber;
@property (nonatomic, strong) NSString* dateOfBirth;
@property (nonatomic, strong) NSString* address;

- (NSDictionary*) toDictionary;
- (instancetype) initWithDictionary:(NSDictionary*)dictionary;
@end
