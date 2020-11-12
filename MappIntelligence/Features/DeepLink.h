//
//  DeepLink.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 06/11/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeepLink : NSObject

+ (void)trackDeepLinkFrom:(NSUserActivity *) activity;

@end

NS_ASSUME_NONNULL_END
