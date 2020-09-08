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

NS_ASSUME_NONNULL_BEGIN

@interface ActionEvent : TrackingEvent

@property (nonatomic, nonnull) ActionProperties* actionProperties;
@property (nonatomic, nonnull) PageProperties* pageProperties;

-(instancetype)initWith: (ActionProperties*) actionProperties andPageProperties:(PageProperties*) pageProperties;
@end

NS_ASSUME_NONNULL_END
