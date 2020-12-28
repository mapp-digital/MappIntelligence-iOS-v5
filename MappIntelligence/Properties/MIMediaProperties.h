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

@property (nonnull) NSString *action;
@property double bandwith;
@property NSTimeInterval duration;
@property (nullable) NSMutableDictionary* groups;
@property (nullable) NSString *name;
@property NSTimeInterval position;
@property BOOL soundIsMuted;
@property double soundVolume;

-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
