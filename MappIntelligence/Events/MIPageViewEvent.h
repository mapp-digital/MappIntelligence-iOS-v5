 
    
//
//  MIPageViewEvent.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIPageProperties.h"
#import "MITrackingEvent.h"
#import "MISessionProperties.h"
#import "MIUserProperties.h"
#import "MIEcommerceProperties.h"
#import "MIAdvertisementProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIPageViewEvent : MITrackingEvent

@property (nonatomic, nonnull) MIPageProperties* pageProperties;
@property (nonatomic, nullable) MISessionProperties *sessionProperties;
@property (nonatomic, nullable) MIUserProperties *userProperties;
@property (nonatomic, nullable) MIEcommerceProperties *ecommerceProperties;
@property (nonatomic, nullable) MIAdvertisementProperties *advertisementProperties;

- (instancetype)initWithName:(NSString *)name pageProperties:(MIPageProperties *)pageProperties;

- (instancetype)initWithName:(NSString *)name pageProperties:(MIPageProperties *)pageProperties sessionProperties: (MISessionProperties *_Nullable) sessionProperties userProperties: (MIUserProperties *_Nullable)userProperties ecommerceProperties: (MIEcommerceProperties *_Nullable) ecommerceProperties advertisementProperties: (MIAdvertisementProperties *_Nullable) advertisementProperties;
@end

NS_ASSUME_NONNULL_END

