//
//  UserProperties.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 20/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct Birthdays {
    int day;
    int month;
    int year;
} Birthday;

typedef NS_ENUM(NSInteger, Gender) {
    unknown,
    male,
    female
    
};

@interface UserProperties : NSObject

@property Birthday birthday;
@property (nullable) NSString *city;
@property (nullable) NSString *country;
@property (nullable) NSDictionary<NSNumber* ,NSArray<NSString*>*> *details;
@property (nullable) NSString *emailAddress;
@property (nullable) NSString *emailReceiverId;
@property (nullable) NSString *firstName;
@property Gender gender;
@property (nullable) NSString *customerId;
@property (nullable) NSString *lastName;
@property BOOL newsletterSubscribed;
@property (nullable) NSString *phoneNumber;
@property (nullable) NSString *street;
@property (nullable) NSString *streetNumber;
@property (nullable) NSString *zipCode;

-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
