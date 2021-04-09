//
//  MIPageParameters.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 17/07/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIPageParameters : NSObject

@property (nullable) NSString* internalSearch;
@property (nullable) NSDictionary<NSNumber* ,NSString*> *details;
@property (nullable) NSMutableDictionary* groups;

-(instancetype)initWithPageParams: (NSDictionary<NSNumber* ,NSString*>* _Nullable) parameters pageCategory: (NSMutableDictionary* _Nullable) category search: (NSString* _Nullable)internalSearch;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
