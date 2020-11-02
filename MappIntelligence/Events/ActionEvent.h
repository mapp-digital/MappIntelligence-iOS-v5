//
//  ActionEvent.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackingEvent.h"
#import "PageProperties.h"
#import "ActionProperties.h"
#import "SessionProperties.h"
#import "UserProperties.h"
#import "EcommerceProperties.h"
#import "AdvertisementProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActionEvent : TrackingEvent

@property (nullable) NSString* name;
@property (nonatomic, nonnull) ActionProperties* actionProperties;
@property (nonatomic, nullable) SessionProperties *sessionProperties;
@property (nonatomic, nullable) UserProperties *userProperties;
@property (nonatomic, nullable) EcommerceProperties *ecommerceProperties;
@property (nonatomic, nullable) AdvertisementProperties *advertisementProperties;

-(instancetype)initWithName: (NSString *)name pageName: (NSString *)pageName actionProperties: (ActionProperties*) actionProperties sessionProperties: (SessionProperties *_Nullable)sessionProperties userProperties: (UserProperties *_Nullable)userProperties ecommerceProperties: (EcommerceProperties *_Nullable)ecommerceProperties advertisementProperties: (AdvertisementProperties *_Nullable) advertisementProperties;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;
@end

NS_ASSUME_NONNULL_END
