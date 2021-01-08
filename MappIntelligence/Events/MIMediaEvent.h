//
//  MIMediaEvent.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMediaProperties.h"
#import "MIActionProperties.h"
#import "MISessionProperties.h"
#import "MIEcommerceProperties.h"


NS_ASSUME_NONNULL_BEGIN

@interface MIMediaEvent : MITrackingEvent


@property (nonatomic, nonnull) MIMediaProperties *mediaProperties;
@property (nonatomic, nullable) MIActionProperties* actionProperties;
@property (nonatomic, nullable) MISessionProperties *sessionProperties;
@property (nonatomic, nullable) MIEcommerceProperties *ecommerceProperties;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPageName:(NSString *)name properties: (MIMediaProperties *)properties;

@end

NS_ASSUME_NONNULL_END
