//
//  MIMediaProperties.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 27/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIMediaProperties : NSObject

@property (nonnull) NSString *name;
@property (nonnull) NSString *action;
@property double bandwith;
@property NSTimeInterval duration;
@property (nullable) NSMutableDictionary* groups;
@property NSTimeInterval position;
@property BOOL soundIsMuted;
@property double soundVolume;
@property (nullable) NSDictionary<NSNumber* ,NSString*>* customProperties;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWith: (NSString *) name action: (NSString *)action postion: (NSTimeInterval) position duration: (NSTimeInterval) duration;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
