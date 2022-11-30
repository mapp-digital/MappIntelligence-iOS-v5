 
    
//
//  MIPageViewEvent.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIPageParameters.h"
#import "MITrackingEvent.h"
#import "MISessionParameters.h"
#import "MIUserCategories.h"
#import "MIEcommerceParameters.h"
#import "MICampaignParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIPageViewEvent : MITrackingEvent

@property (nonatomic, nonnull) MIPageParameters* pageParameters;
@property (nonatomic, nullable) MISessionParameters *sessionParameters;
@property (nonatomic, nullable) MIUserCategories *userCategories;
@property (nonatomic, nullable) MIEcommerceParameters *ecommerceParameters;
@property (nonatomic, nullable) MICampaignParameters *campaignParameters;

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

