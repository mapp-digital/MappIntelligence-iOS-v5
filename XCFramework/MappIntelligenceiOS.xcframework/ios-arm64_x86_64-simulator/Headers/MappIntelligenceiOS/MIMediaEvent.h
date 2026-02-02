//
//  MIMediaEvent.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMediaParameters.h"
#import "MIEventParameters.h"
#import "MISessionParameters.h"
#import "MIEcommerceParameters.h"
#import "MITrackingEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIMediaEvent : MITrackingEvent

@property (nonatomic, nonnull) MIMediaParameters *mediaParameters;
@property (nonatomic, nullable) MIEventParameters* eventParameters;
@property (nonatomic, nullable) MISessionParameters *sessionParameters;
@property (nonatomic, nullable) MIEcommerceParameters *ecommerceParameters;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPageName:(NSString *)name parameters: (MIMediaParameters *)properties;

@end

NS_ASSUME_NONNULL_END
