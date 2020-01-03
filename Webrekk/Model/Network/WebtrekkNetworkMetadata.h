//
//  WebtrekkNetworkMetadata.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebtrekkNetworkMetadata : NSObject

@property (nonatomic, getter = isSuccess) BOOL succes;
@property (nonatomic) NSInteger code;
@property (nonatomic, strong) NSString *message;

- (id)initWithKeyedValues:(NSDictionary *)keyedValues;

@end

