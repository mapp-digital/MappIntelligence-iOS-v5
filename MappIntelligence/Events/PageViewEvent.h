 
    
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

NS_ASSUME_NONNULL_BEGIN

@interface PageViewEvent : TrackingEvent

@property (nonatomic, nonnull) PageProperties* pageProperties;
-(instancetype)initWith: (PageProperties*) properties;

@end

NS_ASSUME_NONNULL_END

