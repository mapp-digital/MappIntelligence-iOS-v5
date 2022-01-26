//
//  MIFormParameters.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import "MIFormParameters.h"

#define key_form_name @"mi_form_name"
#define key_form_submit @"mi_form_submit"
#define key_form_fields @"mi_form_fields"

@implementation MIFormParameters

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        _formName = dictionary[key_form_name];
        _formSubmit = dictionary[key_form_submit];
        NSArray<NSDictionary*>* formFields = dictionary[key_form_fields];
        if (formFields && [formFields count] > 0) {
            _fields = [NSMutableArray new];
            for (NSDictionary* dict in formFields) {
                _fields = [_fields arrayByAddingObject:[[MIFormField alloc] initWithDictionary:dict]];
            }
        }
    }
    return self;
}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"ft" value:[self getFormForQuery]]];
    for (MIFormField* field in _fields) {
       [items addObject:[[NSURLQueryItem alloc] initWithName:@"ft" value:[field getFormFieldForQuery]]];
    }
    return items;
}

- (NSString*)getFormForQuery {
    return [[NSString alloc] initWithFormat:@"%@|%i", _formName, _formSubmit];
}

@end
