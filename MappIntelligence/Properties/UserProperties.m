//
//  UserProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 20/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "UserProperties.h"


@implementation UserProperties

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray<NSURLQueryItem*>*)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_birthday.day && _birthday.month && _birthday.year) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc707" value: [self getBirthday]]];
    }
    if (_city) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc709" value:_city]];
    }
    if (_country) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc709" value:_country]];
    }
    if (_emailAddress) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc700" value:_emailAddress]];
    }
    if (_emailReceiverId) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc701" value:_emailReceiverId]];
    }
    if (_firstName) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc703" value:_firstName]];
    }
    if (_gender) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc706" value: [NSString stringWithFormat:@"%ld", (long)_gender]]];
    }
    if (_customerId) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cd" value:_customerId]];
    }
    if (_lastName) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc704" value:_lastName]];
    }
    if (_newsletterSubscribed) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc703" value: (_newsletterSubscribed ? @"1" : @"2")]];
    }
    if (_phoneNumber) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc705" value:_phoneNumber]];
    }
    if (_street) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc711" value:_street]];
    }
    if (_streetNumber) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc712" value:_streetNumber]];
    }
    if (_zipCode) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc710" value:_zipCode]];
    }
    return items;
}

- (NSString *) getBirthday {
    if (_birthday.day && _birthday.month && _birthday.year) {
        return [NSString stringWithFormat:@"%4d%2d%2d", _birthday.year, _birthday.month, _birthday.day];
    }
    return @"";
}

@end
