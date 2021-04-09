//
//  MIActionProperties.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIEventParameters : NSObject

@property (nullable) NSDictionary<NSNumber* ,NSString*>* parameters;

-(instancetype)initWithParameters: (NSDictionary<NSNumber* ,NSString*>* _Nullable) parameters;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
