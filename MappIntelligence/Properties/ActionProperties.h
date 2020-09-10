//
//  ActionProperties.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackerRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActionProperties : NSObject

@property (nullable) NSString* name;
@property (nullable) NSMutableDictionary* details;

-(instancetype)initWithName: (NSString* _Nullable) name andDetails: (NSMutableDictionary* _Nullable) details;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItemsFor: (TrackerRequest*)request;

@end

NS_ASSUME_NONNULL_END
