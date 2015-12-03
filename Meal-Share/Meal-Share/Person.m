//
//  Person.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 11/12/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "Person.h"

#define safeSet(d,k,v) if (v) d[k] = v;

@implementation Person

- (instancetype) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        //NSLog(@"dictionary: %@",dictionary[@"title"]);
        _email = dictionary[@"email"];
        _password = dictionary[@"password"];
        _firstName = dictionary[@"firstName"];
        _lastName = dictionary[@"lastName"];
        _creditCardNumber = dictionary[@"creditCardNumber"];
        _dateOfBirth = dictionary[@"dateOfBirth"];
        _address = dictionary[@"address"];
    }
    return self;
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"email", self.email);
    safeSet(jsonable, @"password", self.password);
    safeSet(jsonable, @"firstName", self.firstName);
    safeSet(jsonable, @"lastName", self.lastName);
    safeSet(jsonable, @"creditCardNumber", self.creditCardNumber);
    safeSet(jsonable, @"dateOfBirth", self.dateOfBirth);
    safeSet(jsonable, @"address", self.address);
    // safeSet(jsonable, @"_id", self.mealId);
   
    
    return jsonable;
}

@end
