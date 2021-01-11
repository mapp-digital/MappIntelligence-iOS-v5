//
//  MIMediaTracker.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/01/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMediaEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIMediaTracker : NSObject

+ (nullable instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
