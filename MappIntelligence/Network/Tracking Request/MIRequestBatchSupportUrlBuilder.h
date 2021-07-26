//
//  MIRequestBatchSupportUrlBuilder.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 02/07/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIRequestBatchSupportUrlBuilder : NSObject

@property NSString* baseUrl;
-(void)sendBatchForRequestsInBackground: (BOOL) background withCompletition:(void (^)(NSError *error))handler;

@end

NS_ASSUME_NONNULL_END
