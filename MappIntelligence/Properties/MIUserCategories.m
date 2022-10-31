//
//  MIUserCategories.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 20/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIUserCategories.h"
#import "MIDefaultTracker.h"

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

@implementation MIUserCategories

- (instancetype)initWithCustomProperties: (NSDictionary<NSNumber* ,NSString*>* _Nullable) properties {
    self = [super init];
    if (self) {
        _customCategories = properties;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        NSDictionary* brthday = dictionary[key_birthday];
        [self setBirthdayFrom:brthday];
        _city = dictionary[key_city];
        _country = dictionary[key_country];
        _emailAddress = dictionary[key_email_address];
        _emailReceiverId = dictionary[key_email_receiver_id];
        _firstName = dictionary[key_first_name];
        _gender = [self setGenderFromInt:[[dictionary valueForKey:key_gender] longValue]];
        _customerId = dictionary[key_customer_id];
        _lastName = dictionary[key_last_name];
        _newsletterSubscribed = [dictionary[key_newsletter_subscribed] boolValue];
        _phoneNumber = dictionary[key_phone_number];
        _street = dictionary[key_street];
        _streetNumber = dictionary[key_street_number];
        _zipCode = dictionary[key_zip_code];
        _customCategories = dictionary[key_custom_categories];
        
    }
    return self;
}

- (void)setBirthdayFrom: (NSDictionary*) brthday {
    if (brthday){
        MIBirthday bDay;
        NSNumber* day = brthday[key_birthday_day];
        if (day) {
            bDay.day = [day intValue];
        }
        NSNumber* month = brthday[key_birthday_month];
        if (month) {
            bDay.month = [month intValue];
        }
        NSNumber* year = brthday[key_birthday_year];
        if (year) {
            bDay.year = [year intValue];
        }
        if (bDay.day) {
            _birthday = bDay;
        }
    }
}

- (MIGender)setGenderFromInt:(long)gender {
    switch (gender) {
        case 2:
            return male;
        case 3:
            return female;
        default:
            return unknown;
    }
}

- (NSMutableArray<NSURLQueryItem*>*)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    if (_customCategories) {
        _customCategories = [self filterCustomDict:_customCategories];
        for(NSNumber* key in _customCategories) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"uc%@",key] value: _customCategories[key]]];
        }
    }
    
    if (_birthday.day && _birthday.month && _birthday.year) {
        items = [self removeObjectWith:@"uc707" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc707" value: [self getBirthday]]];
    }
    if (_city) {
        items = [self removeObjectWith:@"uc709" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc709" value:_city]];
    }
    if (_country) {
        items = [self removeObjectWith:@"uc708" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc708" value:_country]];
    }
    if (_emailAddress) {
        items = [self removeObjectWith:@"uc700" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc700" value:_emailAddress]];
    }
    if (_emailReceiverId) {
        items = [self removeObjectWith:@"uc701" from:items];
        if (![[MIDefaultTracker sharedInstance] anonymousTracking]) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc701" value:_emailReceiverId]];
        }
    }
    if (_firstName) {
        items = [self removeObjectWith:@"uc703" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc703" value:_firstName]];
    }
    if (_gender) {
        items = [self removeObjectWith:@"uc706" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc706" value: [NSString stringWithFormat:@"%ld", (long)_gender - 1]]];
    }
    if (_customerId) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cd" value:_customerId]];
    }
    if (_lastName) {
        items = [self removeObjectWith:@"uc704" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc704" value:_lastName]];
    }
    
    items = [self removeObjectWith:@"uc702" from:items];
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc702" value: (_newsletterSubscribed ? @"1" : @"2")]];
    
    if (_phoneNumber) {
        items = [self removeObjectWith:@"uc705" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc705" value:_phoneNumber]];
    }
    if (_street) {
        items = [self removeObjectWith:@"uc711" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc711" value:_street]];
    }
    if (_streetNumber) {
        items = [self removeObjectWith:@"uc712" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc712" value:_streetNumber]];
    }
    if (_zipCode) {
        items = [self removeObjectWith:@"uc710" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc710" value:_zipCode]];
    }
    return items;
}

- (NSString *) getBirthday {
    if (_birthday.day && _birthday.month && _birthday.year) {
        return [NSString stringWithFormat:@"%4d%02d%02d", _birthday.year, _birthday.month, _birthday.day];
    }
    return @"";
}

- (NSDictionary<NSNumber* ,NSString*> *) filterCustomDict: (NSDictionary<NSNumber* ,NSString*> *) dict{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSNumber *idx in dict) {
        if (idx.intValue > 0) {
            [result setObject:dict[idx] forKey:idx];
        }
    }
    return result;
}

- (NSMutableArray<NSURLQueryItem*>*) removeObjectWith:(NSString *) name from: (NSMutableArray<NSURLQueryItem*> *) items {
    NSURLQueryItem *itemToRemove = nil;
    for (NSURLQueryItem *item in items) {
        if (item.name == name) {
            itemToRemove = item;
        }
    }
    if (itemToRemove) {
        [items removeObject:itemToRemove];
    }
    return items;
}
@end
