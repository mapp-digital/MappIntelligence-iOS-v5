//
//  MISessionProperties.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 11/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITrackerRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MISessionProperties : NSObject
@property (nullable) NSDictionary<NSNumber* ,NSArray<NSString*>*>* properties;
-(instancetype)initWithProperties: (NSDictionary<NSNumber* ,NSArray<NSString*>*>* _Nullable) properties;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;
@end

NS_ASSUME_NONNULL_END
