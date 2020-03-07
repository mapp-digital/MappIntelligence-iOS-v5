//
//  RequestUrlBuilder.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestUrlBuilder : NSObject

-(instancetype)initWithUrl: (NSURL*) serverUrl andWithId: (NSString*) mappIntelligenceId;

@end

NS_ASSUME_NONNULL_END
