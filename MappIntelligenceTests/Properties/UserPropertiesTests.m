//
//  MIUserCategories.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 22/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIUserCategories.h"

#define key_birthday @"birthday"

#define key_birthday_day @"day"
#define key_birthday_month @"month"
#define key_birthday_year @"year"

#define key_city @"city"
#define key_country @"country"
#define key_email_address @"emailAddress"
#define key_email_receiver_id @"emailReceiverId"
#define key_first_name @"firstName"
#define key_gender @"gender"
#define key_customer_id @"customerId"
#define key_last_name @"lastName"
#define key_newsletter_subscribed @"newsletterSubscribed"
#define key_phone_number @"phoneNumber"
#define key_street @"street"
#define key_street_number @"streetNumber"
#define key_zip_code @"zipCode"
#define key_custom_categories @"customCategories"

@interface UserPropertiesTests : XCTestCase
@property MIUserCategories* userProperties;
@property MIUserCategories* userPropertiesFromDict;
@property NSMutableDictionary* parameters;
@property NSDictionary* dictionary;

@property MIBirthday birthday;
@property NSString *city;
@property NSString *country;
@property NSString *emailAddress;
@property NSString *emailReceiverId;
@property NSString *firstName;
@property MIGender gender;
@property NSString *customerId;
@property NSString *lastName;
@property BOOL newsletterSubscribed;
@property NSString *phoneNumber;
@property NSString *street;
@property NSString *streetNumber;
@property NSString *zipCode;
@property NSDictionary<NSNumber* ,NSString*>* customCategories;
@end

@implementation UserPropertiesTests

static MIBirthday dataInit = { .day = 1, .month = 2, .year = 1991};

- (void)setUp {
    _parameters = [@{@20: @"1 element"} copy];
    _userProperties = [[MIUserCategories alloc] initWithCustomProperties:_parameters];
    [self createDictionary];
    _userPropertiesFromDict = [[MIUserCategories alloc] initWithDictionary:_dictionary];
}

-(void)createDictionary {
    _birthday = dataInit;
    _city = @"Nis";
    _country = @"Serbia";
    _emailAddress = @"testemail@mapp.com";
    _emailReceiverId = @"email_receiver_id";
    _firstName = @"Stefan";
    _gender = male;
    _customerId = @"customer_id";
    _lastName = @"Stevanovic";
    _newsletterSubscribed = NO;
    _phoneNumber = @"+38134643654352";
    _street = @"Orlovica Pavla";
    _streetNumber =  @"5";
    _zipCode = @"1800";
    _customCategories =  @{@12: @"custom_categories"};
    
    _dictionary = @{key_birthday: [self setBirthdayFrom:_birthday], key_city: _city, key_country: _country, key_email_address: _emailAddress, key_email_receiver_id: _emailReceiverId, key_first_name: _firstName, key_gender: @((int)_gender), key_customer_id: _customerId, key_last_name: _lastName, key_newsletter_subscribed: [NSNumber numberWithBool:_newsletterSubscribed], key_phone_number: _phoneNumber, key_street: _street, key_street_number:_streetNumber, key_zip_code: _zipCode, key_custom_categories:_customCategories};
}

- (NSDictionary*)setBirthdayFrom: (MIBirthday) birthday {
    return @{key_birthday_day: @(birthday.day), key_birthday_month: @(birthday.month), key_birthday_year: @(birthday.year)};
}

- (void)tearDown {
    _parameters = NULL;
    _userProperties = NULL;
    _dictionary = NULL;
    _userPropertiesFromDict = NULL;
    _city = NULL;
    _country = NULL;
    _emailAddress = NULL;
    _emailReceiverId = NULL;
    _firstName = NULL;
    _customerId = NULL;
    _lastName = NULL;
    _phoneNumber = NULL;
    _street = NULL;
    _streetNumber =  NULL;
    _zipCode = NULL;
    _customCategories =  NULL;
}

- (void)testInitWIthCustomParameters {
    _userProperties.birthday = _birthday;
    _userProperties.city = _city;
    _userProperties.country = _country;
    _userProperties.emailAddress = _emailAddress;
    _userProperties.emailReceiverId = _emailReceiverId;
    _userProperties.firstName = _firstName;
    _userProperties.gender = _gender;
    _userProperties.customerId = _customerId;
    _userProperties.lastName = _lastName;
    _userProperties.newsletterSubscribed = _newsletterSubscribed;
    _userProperties.phoneNumber = _phoneNumber;
    _userProperties.street = _street;
    _userProperties.streetNumber = _streetNumber;
    _userProperties.zipCode = _zipCode;
    
    XCTAssertTrue([_userProperties.customCategories isEqualToDictionary:_parameters], @"The details from action properties is not same as it is used for creation!");
    
    XCTAssertTrue([[self setBirthdayFrom:_userProperties.birthday] isEqualToDictionary:[self setBirthdayFrom:_birthday]], @"There is no birthday!");
    XCTAssertTrue([_userProperties.city isEqualToString:_city], @"The city is not correct!");
    XCTAssertTrue([_userProperties.country isEqualToString:_country], @"The country is not correct!");
    XCTAssertTrue([_userProperties.emailAddress isEqualToString:_emailAddress], @"The email address is not correct!");
    XCTAssertTrue([_userProperties.emailReceiverId isEqualToString:_emailReceiverId], @"The email receiver id is not correct!");
    XCTAssertTrue([_userProperties.firstName isEqualToString:_firstName], @"The first name is not correct!");
    XCTAssertTrue((int)_userProperties.gender == (int)_gender, @"The gender is not correct!");
    XCTAssertTrue([_userProperties.customerId isEqualToString:_customerId], @"The customer id is not correct!");
    XCTAssertTrue([_userProperties.lastName isEqualToString:_lastName], @"The last name is not correct!");
    XCTAssertTrue(_userProperties.newsletterSubscribed == _newsletterSubscribed, @"The newsletter subscribed flag is not correct!");
    XCTAssertTrue([_userProperties.phoneNumber isEqualToString:_phoneNumber], @"The phone number is not correct!");
    XCTAssertTrue([_userProperties.street isEqualToString:_street], @"The street is not correct!");
    XCTAssertTrue([_userProperties.streetNumber isEqualToString:_streetNumber], @"The street number is not correct!");
    XCTAssertTrue([_userProperties.zipCode isEqualToString:_zipCode], @"The zip code is not correct!");
    
}

- (void)testAsQueryItemsForRequest {
    //1. create expected query items
    NSMutableArray<NSURLQueryItem*>* result = [_userPropertiesFromDict asQueryItems];
    if (_customCategories) {
        for(NSString* key in [_customCategories allKeys]) {
            NSURLQueryItem* tempItem = [[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"uc%@",key] value: _customCategories[key]];
            XCTAssertTrue([result containsObject:tempItem], @"Custom category is not the same!");
            
        }
    }
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc707" value: [self getBirthday]]], @"Birthday is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc709" value:_city]], @"City is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc708" value:_country]], @"Country is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc700" value:_emailAddress]], @"Email address is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc701" value:_emailReceiverId]], @"Email Receiver ID is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc703" value:_firstName]], @"First Name is not the same!");
    NSURLQueryItem* genderItem = [[NSURLQueryItem alloc] initWithName:@"uc706" value: [NSString stringWithFormat:@"%ld", (long)_gender - 1]];
    XCTAssertTrue([result containsObject:genderItem], @"Gender is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"cd" value:_customerId]], @"Customer id is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc704" value:_lastName]], @"Last name is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc702" value: (_newsletterSubscribed ? @"1" : @"2")]], @"Newletter subscribed flag is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc705" value:_phoneNumber]], @"Phone number is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc711" value:_street]], @"Street is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc712" value:_streetNumber]], @"Street number is not the same!");
    XCTAssertTrue([result containsObject:[[NSURLQueryItem alloc] initWithName:@"uc710" value:_zipCode]], @"Zip code is not the same!");
}

- (NSString *) getBirthday {
    if (_birthday.day && _birthday.month && _birthday.year) {
        return [NSString stringWithFormat:@"%4d%02d%02d", _birthday.year, _birthday.month, _birthday.day];
    }
    return @"";
}

- (void)testInitWithDictionary {
    XCTAssertTrue([[self setBirthdayFrom:_userPropertiesFromDict.birthday] isEqualToDictionary:[self setBirthdayFrom:_birthday]], @"There is no birthday!");
    XCTAssertTrue([_userPropertiesFromDict.city isEqualToString:_city], @"The city is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.country isEqualToString:_country], @"The country is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.emailAddress isEqualToString:_emailAddress], @"The email address is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.emailReceiverId isEqualToString:_emailReceiverId], @"The email receiver id is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.firstName isEqualToString:_firstName], @"The first name is not correct!");
    XCTAssertTrue((int)_userPropertiesFromDict.gender == (int)_gender, @"The gender is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.customerId isEqualToString:_customerId], @"The customer id is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.lastName isEqualToString:_lastName], @"The last name is not correct!");
    XCTAssertTrue(_userPropertiesFromDict.newsletterSubscribed == _newsletterSubscribed, @"The newsletter subscribed flag is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.phoneNumber isEqualToString:_phoneNumber], @"The phone number is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.street isEqualToString:_street], @"The street is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.streetNumber isEqualToString:_streetNumber], @"The street number is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.zipCode isEqualToString:_zipCode], @"The zip code is not correct!");
    XCTAssertTrue([_userPropertiesFromDict.customCategories isEqualToDictionary:_customCategories], @"The custom categories is not correct!");
}

@end
