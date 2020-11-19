//
//  MIRequestUrlBuilder.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackerRequest.h"
#import "Request.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIRequestUrlBuilder : NSObject

@property Request *dbRequest;

-(instancetype)initWithUrl: (NSURL*) serverUrl andWithId: (NSString*) mappIntelligenceId;
-(NSURL*)urlForRequest: (TrackerRequest*) request;
- (NSURL *)createURLFromParametersWith:(NSArray<NSURLQueryItem *> *)parameters;
@end

NS_ASSUME_NONNULL_END
