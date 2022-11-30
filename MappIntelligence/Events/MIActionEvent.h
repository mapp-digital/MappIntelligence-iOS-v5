//
//  MIActionEvent.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITrackingEvent.h"
#import "MIPageParameters.h"
#import "MIEventParameters.h"
#import "MISessionParameters.h"
#import "MIUserCategories.h"
#import "MIEcommerceParameters.h"
#import "MICampaignParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIActionEvent : MITrackingEvent
@property (nonnull) NSString* name;
@property (nonatomic, nonnull) MIEventParameters* eventParameters;
@property (nonatomic, nullable) MISessionParameters *sessionParameters;
@property (nonatomic, nullable) MIUserCategories *userCategories;
@property (nonatomic, nullable) MIEcommerceParameters *ecommerceParameters;
@property (nonatomic, nullable) MICampaignParameters *campaignParameters;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;
@end

NS_ASSUME_NONNULL_END
