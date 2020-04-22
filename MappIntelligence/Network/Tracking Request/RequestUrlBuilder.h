//
//  RequestUrlBuilder.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackerRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestUrlBuilder : NSObject

-(instancetype)initWithUrl: (NSURL*) serverUrl andWithId: (NSString*) mappIntelligenceId;
-(NSURL*)urlForRequest: (TrackerRequest*) request;

@end

NS_ASSUME_NONNULL_END
