//
//  MIMediaParameters.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 27/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIMediaParameters : NSObject

@property (nonnull) NSString *name;
@property (nonnull) NSString *action;
@property (nullable) NSNumber *bandwith;
@property (nonnull) NSNumber *duration;
@property (nonnull) NSNumber *position;
@property (nullable)NSNumber *soundIsMuted;
@property (nullable)NSNumber *soundVolume;
@property (nullable) NSDictionary<NSNumber* ,NSString*>* customCategories;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWith: (NSString *) name action: (NSString *)action position: (NSNumber *) position duration: (NSNumber *) duration;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
