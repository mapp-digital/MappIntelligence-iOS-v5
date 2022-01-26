//
//  MIFormField.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import "MIFormField.h"

#define key_field_name @"mi_form_field_name"
#define key_field_content @"mi_field_content"
#define key_last_focus @"mi_last_focus"

@implementation MIFormField

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        _formFieldName = dictionary[key_field_name];
        _formFieldContent = dictionary[key_field_content];
        _lastFocus = dictionary[key_last_focus];
    }
    return self;

}

- (NSString *)formFieldName {
    return (_formFieldName == NULL) ? @"" : _formFieldName;
}

- (NSString *)formFieldContent {
    return (_formFieldContent == NULL) ? @"" : _formFieldContent;
}

- (BOOL)lastFocus {
    return _lastFocus ? _lastFocus : NO;
}

- (NSString *)getFormFieldForQuery {
    return [[NSString alloc] initWithFormat:@"%@|%@|%i", _formFieldName, _formFieldContent, _lastFocus ];
}

@end
