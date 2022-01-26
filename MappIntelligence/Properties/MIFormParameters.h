//
//  MIFormParameters.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIFormField.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIFormParameters : NSObject

@property (nonatomic, nullable) NSString* formName;
@property (nonatomic) BOOL formSubmit;
@property (nullable) NSArray<MIFormField*>* fields;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
