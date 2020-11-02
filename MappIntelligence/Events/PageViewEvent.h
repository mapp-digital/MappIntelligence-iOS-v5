 
    
//
//  PageViewEvent.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageProperties.h"
#import "TrackingEvent.h"
#import "SessionProperties.h"
#import "UserProperties.h"
#import "EcommerceProperties.h"
#import "AdvertisementProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageViewEvent : TrackingEvent

@property (nonatomic, nonnull) PageProperties* pageProperties;
@property (nonatomic, nullable) SessionProperties *sessionProperties;
@property (nonatomic, nullable) UserProperties *userProperties;
@property (nonatomic, nullable) EcommerceProperties *ecommerceProperties;
@property (nonatomic, nullable) AdvertisementProperties *advertisementProperties;

- (instancetype)initWithName:(NSString *)name pageProperties:(PageProperties *)pageProperties;

- (instancetype)initWithName:(NSString *)name pageProperties:(PageProperties *)pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties userProperties: (UserProperties *_Nullable)userProperties ecommerceProperties: (EcommerceProperties *_Nullable) ecommerceProperties advertisementProperties: (AdvertisementProperties *_Nullable) advertisementProperties;
@end

NS_ASSUME_NONNULL_END

