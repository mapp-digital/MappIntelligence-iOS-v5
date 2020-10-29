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
#import "AdvertisementProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActionEvent : TrackingEvent

@property (nullable) NSString* name;
@property (nonatomic, nonnull) ActionProperties* actionProperties;
@property (nonatomic, nullable) SessionProperties *sessionProperties;
@property (nonatomic, nullable) AdvertisementProperties *advertisementProperties;

-(instancetype)initWithName: (NSString *)name pageName: (NSString *)pageName actionProperties: (ActionProperties*) actionProperties sessionProperties: (SessionProperties *_Nullable)sessionProperties;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;
@end

NS_ASSUME_NONNULL_END
