//
//  DeepLink.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 06/11/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAdvertisementProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDeepLink : NSObject

+ (MIAdvertisementProperties *_Nullable) loadCampaign;
+ (NSError *_Nullable) deleteCampaign;
+ (NSError *_Nullable)trackFromUrl:(NSURL *_Nullable) url withMediaCode: (NSString *_Nullable) mediaCode;

@end

NS_ASSUME_NONNULL_END
