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
#define key_anonymus @"mi_anonymus"

@implementation MIFormField

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        _formFieldName = dictionary[key_field_name];
        _formFieldContent = dictionary[key_field_content];
        _lastFocus = dictionary[key_last_focus];
        _anonymus = dictionary[key_anonymus];
    }
    return self;

}

- (instancetype)initWithName:(NSString *)name andContent:(NSString *)content andID:(NSInteger)ID andWithAnonymus:(BOOL)anonymus {
    self = [super init];
    if (self) {
        _formFieldName = name;
        _formFieldContent = content;
        _anonymus = anonymus;
        _ID = ID;
    }
    return self;
}

- (NSString *)setformFieldName {
    return (_formFieldName == NULL) ? @"" : _formFieldName;
}

- (NSString *)setformFieldContent {
    if (_anonymus) {
        if ([_formFieldContent isEqualToString: @""]) {
            return @"empty";
        } else {
            return @"filled_out";
        }
    }
    return (_formFieldContent == NULL) ? @"" : _formFieldContent;
}

- (BOOL)setlastFocus {
    return _lastFocus ? _lastFocus : NO;
}

- (NSString *)getFormFieldForQuery {
    return [[NSString alloc] initWithFormat:@"%@|%@|%i", [self setformFieldName], [self setformFieldContent], [self setlastFocus] ];
}

@end
