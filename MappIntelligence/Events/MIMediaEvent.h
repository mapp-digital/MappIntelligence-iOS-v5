//
//  MIMediaEvent.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMediaParameters.h"
#import "MIActionProperties.h"
#import "MISessionProperties.h"
#import "MIEcommerceProperties.h"


NS_ASSUME_NONNULL_BEGIN

@interface MIMediaEvent : MITrackingEvent

@property (nonatomic, nonnull) MIMediaParameters *mediaParameters;
@property (nonatomic, nullable) MIActionProperties* actionProperties;
@property (nonatomic, nullable) MISessionProperties *sessionProperties;
@property (nonatomic, nullable) MIEcommerceProperties *ecommerceProperties;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPageName:(NSString *)name parameters: (MIMediaParameters *)properties;

@end

NS_ASSUME_NONNULL_END
