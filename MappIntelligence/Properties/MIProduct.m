//
//  Product.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIProduct.h"

#define key_name @"name"
#define key_cost @"cost"
#define key_quantity @"quantity"
#define key_categories @"categories"

@implementation MIProduct

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        _name = dictionary[key_name];
        _cost = dictionary[key_cost];
        _quantity = dictionary[key_quantity];
        _categories = dictionary[key_categories];
    }
    return self;

}

- (NSString *)name {
    return (_name == NULL) ? @"" : _name;
}

@end
