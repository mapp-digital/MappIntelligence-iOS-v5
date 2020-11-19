 
    
//
//  MIPageViewEvent.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIPageProperties.h"
#import "TrackingEvent.h"
#import "MISessionProperties.h"
#import "MIUserProperties.h"
#import "MIEcommerceProperties.h"
#import "AdvertisementProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIPageViewEvent : TrackingEvent

@property (nonatomic, nonnull) MIPageProperties* pageProperties;
@property (nonatomic, nullable) MISessionProperties *sessionProperties;
@property (nonatomic, nullable) MIUserProperties *userProperties;
@property (nonatomic, nullable) MIEcommerceProperties *ecommerceProperties;
@property (nonatomic, nullable) AdvertisementProperties *advertisementProperties;

- (instancetype)initWithName:(NSString *)name pageProperties:(MIPageProperties *)pageProperties;

- (instancetype)initWithName:(NSString *)name pageProperties:(MIPageProperties *)pageProperties sessionProperties: (MISessionProperties *_Nullable) sessionProperties userProperties: (MIUserProperties *_Nullable)userProperties ecommerceProperties: (MIEcommerceProperties *_Nullable) ecommerceProperties advertisementProperties: (AdvertisementProperties *_Nullable) advertisementProperties;
@end

NS_ASSUME_NONNULL_END

