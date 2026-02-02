//
//  MIParamType.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 17/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIParamType : NSObject

+(NSString *)pageParam;
+(NSString *)pageCategory;
+(NSString *)ecommerceParam;
+(NSString *)productCategory;
+(NSString *)eventParam;
+(NSString *)campaignParam;
+(NSString *)sessionParam;
+(NSString *)urmCategory;

+(NSString *) createCustomParam:(NSString *) type value: (NSInteger) value;

@end

NS_ASSUME_NONNULL_END
