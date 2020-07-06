//
//  RequestBatchSupportUrlBuilder.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 02/07/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestBatchSupportUrlBuilder : NSObject

@property NSString* baseUrl;
-(void)sendBatchForRequests;

@end

NS_ASSUME_NONNULL_END
