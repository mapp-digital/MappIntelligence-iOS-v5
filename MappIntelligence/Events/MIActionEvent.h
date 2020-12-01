//
//  MIActionEvent.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITrackingEvent.h"
#import "MIPageProperties.h"
#import "MIActionProperties.h"
#import "MISessionProperties.h"
#import "MIUserProperties.h"
#import "MIEcommerceProperties.h"
#import "MICampaignProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIActionEvent : MITrackingEvent
@property (nonnull) NSString* name;
@property (nonatomic, nonnull) MIActionProperties* actionProperties;
@property (nonatomic, nullable) MISessionProperties *sessionProperties;
@property (nonatomic, nullable) MIUserProperties *userProperties;
@property (nonatomic, nullable) MIEcommerceProperties *ecommerceProperties;
@property (nonatomic, nullable) MICampaignProperties *campaignProperties;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;
@end

NS_ASSUME_NONNULL_END
