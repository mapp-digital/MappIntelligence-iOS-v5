 
    
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

NS_ASSUME_NONNULL_BEGIN

@interface PageViewEvent : TrackingEvent

@property (nonatomic, nonnull) PageProperties* pageProperties;
@property (nonatomic, nullable) SessionProperties *sessionProperties;
@property (nonatomic, nullable) UserProperties *userProperties;

- (instancetype)initWithName:(NSString *)name pageProperties:(PageProperties *)pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties userProperties: (UserProperties *_Nullable)userProperties;
@end

NS_ASSUME_NONNULL_END

