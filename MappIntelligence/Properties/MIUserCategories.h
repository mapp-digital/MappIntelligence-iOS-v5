//
//  MIUserCategories.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 20/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct MIBirthday {
    int day;
    int month;
    int year;
} MIBirthday;

typedef NS_ENUM(NSInteger, MIGender) {
    unknown = 1,
    male = 2,
    female = 3
};

@interface MIUserCategories : NSObject

@property MIBirthday birthday;
@property (nullable) NSString *city;
@property (nullable) NSString *country;
@property (nullable) NSString *emailAddress;
@property (nonatomic, nullable) NSString *emailReceiverId;
@property (nullable) NSString *firstName;
@property MIGender gender;
@property (nullable) NSString *customerId;
@property (nullable) NSString *lastName;
@property BOOL newsletterSubscribed;
@property (nullable) NSString *phoneNumber;
@property (nullable) NSString *street;
@property (nullable) NSString *streetNumber;
@property (nullable) NSString *zipCode;
@property (nullable) NSDictionary<NSNumber* ,NSString*>* customCategories;

- (instancetype)initWithCustomProperties: (NSDictionary<NSNumber* ,NSString*>* _Nullable) properties;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
