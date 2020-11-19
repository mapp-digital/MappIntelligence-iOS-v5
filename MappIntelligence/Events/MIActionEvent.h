//
//  MIActionEvent.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackingEvent.h"
#import "MIPageProperties.h"
#import "MIActionProperties.h"
#import "MISessionProperties.h"
#import "MIUserProperties.h"
#import "MIEcommerceProperties.h"
#import "AdvertisementProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIActionEvent : TrackingEvent

@property (nullable) NSString* name;
@property (nonatomic, nonnull) MIActionProperties* actionProperties;
@property (nonatomic, nullable) MISessionProperties *sessionProperties;
@property (nonatomic, nullable) MIUserProperties *userProperties;
@property (nonatomic, nullable) MIEcommerceProperties *ecommerceProperties;
@property (nonatomic, nullable) AdvertisementProperties *advertisementProperties;

-(instancetype)initWithName: (NSString *)name pageName: (NSString *)pageName actionProperties: (MIActionProperties*) actionProperties sessionProperties: (MISessionProperties *_Nullable)sessionProperties userProperties: (MIUserProperties *_Nullable)userProperties ecommerceProperties: (MIEcommerceProperties *_Nullable)ecommerceProperties advertisementProperties: (AdvertisementProperties *_Nullable) advertisementProperties;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;
@end

NS_ASSUME_NONNULL_END
