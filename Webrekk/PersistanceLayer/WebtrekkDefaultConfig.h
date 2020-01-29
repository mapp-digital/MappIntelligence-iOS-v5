//
//  WebtrekkDefaultConfig.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 17/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//
#import "Config.h"

@interface WebtrekkDefaultConfig : NSObject <Config, NSCoding>
-(instancetype) initWithDictionary:(NSDictionary *) dictionary;
@end
