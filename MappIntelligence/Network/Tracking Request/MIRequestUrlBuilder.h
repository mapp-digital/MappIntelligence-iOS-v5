//
//  MIRequestUrlBuilder.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITrackerRequest.h"
#import "MIRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIRequestUrlBuilder : NSObject

@property MIRequest *dbRequest;

-(instancetype)initWithUrl: (NSURL*) serverUrl andWithId: (NSString*) mappIntelligenceId;
-(NSURL *)urlForRequest:(MITrackerRequest *)request withCustomData: (BOOL) custom;
-(NSURL *)createURLFromParametersWith:(NSArray<NSURLQueryItem *> *)parameters;
-(NSString *)codeString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
