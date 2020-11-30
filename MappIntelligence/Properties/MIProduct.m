//
//  Product.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIProduct.h"

@implementation MIProduct

- (NSString *)name {
    return (_name == NULL) ? @"" : _name;
}

@end
