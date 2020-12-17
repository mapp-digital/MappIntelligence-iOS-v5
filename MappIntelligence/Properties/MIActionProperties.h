//
//  MIActionProperties.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITrackerRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIActionProperties : NSObject

@property (nullable) NSDictionary<NSNumber* ,NSString*>* properties;

-(instancetype)initWithProperties: (NSDictionary<NSNumber* ,NSString*>* _Nullable) properties;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
