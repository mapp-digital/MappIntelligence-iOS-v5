//
//  AdvertisementProperties.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdvertisementProperties : NSObject
@property (nullable) NSString *campaignId;
@property (nullable) NSString *action;

@property (nullable) NSDictionary<NSNumber* ,NSArray<NSString*>*>* properties;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
