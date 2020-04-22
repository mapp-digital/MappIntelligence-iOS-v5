//
//  MappIntelligenceDefaultConfig.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 17/01/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//
#import "Config.h"
#import "DefaultTracker.h"

@interface MappIntelligenceDefaultConfig : NSObject <Config, NSCoding>

- (void)logConfig;

@end
