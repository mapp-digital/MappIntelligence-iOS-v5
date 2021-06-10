//
//  AdvertisementProperties.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MICampaignAction) {
    click = 1,
    view = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface MICampaignParameters : NSObject <NSCopying, NSSecureCoding>
@property (nullable) NSString *campaignId;
@property MICampaignAction action;
@property (nullable) NSString *mediaCode;
@property BOOL oncePerSession;
@property (nullable) NSDictionary<NSNumber* ,NSString*>* customParameters;

- (instancetype)initWith: (NSString *) campaignId;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
