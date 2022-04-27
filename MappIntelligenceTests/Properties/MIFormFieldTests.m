//
//  MIFormFieldTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 27.4.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIFormField.h"

#define key_field_name @"mi_form_field_name"
#define key_field_content @"mi_field_content"
#define key_last_focus @"mi_last_focus"
#define key_anonymus @"mi_anonymus"

@interface MIFormFieldTests : XCTestCase

@property NSString* formFieldName;
@property NSString* formFieldContent;
@property NSInteger ID;
@property BOOL lastFocus;
@property BOOL anonymus;

@property NSDictionary* dictionary;
@property MIFormField* field;
@property MIFormField* fieldFromDictionary;

@end

@implementation MIFormFieldTests

- (void)setUp {
    [self setUpDictionary];
    _field = [[MIFormField alloc] initWithName:_formFieldName andContent:_formFieldContent andID:_ID andWithAnonymus:_anonymus andFocus:_lastFocus];
    _fieldFromDictionary = [[MIFormField alloc] initWithDictionary:_dictionary];
}

- (void)setUpDictionary {
    _formFieldName = @"Test.From.Field.Name";
    _formFieldContent = @"TestFormFieldContent";
    _ID = 1315;
    _lastFocus = NO;
    _anonymus = NO;
    
    _dictionary = @{key_field_name: _formFieldName, key_field_content: _formFieldContent, key_last_focus: [NSNumber numberWithBool:_lastFocus], key_anonymus: [NSNumber numberWithBool:_anonymus]};
}

- (void)tearDown {
    _dictionary = NULL;
    _field = NULL;
    _fieldFromDictionary = NULL;
}

- (void)checkField: (MIFormField*) tmpField {
    XCTAssertTrue([tmpField.formFieldName isEqualToString:_formFieldName], @"Field has no good name property!" );
    XCTAssertTrue([tmpField.formFieldContent isEqualToString:_formFieldContent], @"Field has no good content  property!" );
    XCTAssertTrue(tmpField.anonymus == _anonymus, @"Field has no good anonymous value property!" );
    XCTAssertTrue(tmpField.lastFocus == _lastFocus, @"Field has no good last focus value property!" );
}

- (void)testInitWithDictionary {
    [self checkField:_fieldFromDictionary];
}

- (void)testInitWithNameAndContent {
    XCTAssertTrue(_field.ID != 0, @"Field has no good ID!" );
    [self checkField:_field];
}

- (void)testGetFormFieldForQuery {
    NSString* createQuery = [[NSString alloc] initWithFormat:@"%@|%@|%i", [self setformFieldName], [self setformFieldContent], [self setlastFocus] ];
    XCTAssertTrue([createQuery isEqualToString:[_field getFormFieldForQuery]], @"Creation of query field!" );
}

- (void)testRenameField {
    NSString* renameValue = @"testRenameValue";
    [_field renameField:renameValue];
    XCTAssertTrue([_field.formFieldName hasPrefix:renameValue], @"Rename field failed!" );
}

- (NSString *)setformFieldName {
    return (_formFieldName == NULL) ? @"" : _formFieldName;
}

- (NSString *)setformFieldContent {
    if (_anonymus || [_formFieldContent isEqualToString:@"mapp_inteligence_switch"]) {
        if (_formFieldContent == NULL || [_formFieldContent isEqualToString: @""]) {
            return @"empty";
        } else {
            return @"filled_out";
        }
    }
    return (_formFieldContent == NULL || [_formFieldContent isEqualToString: @""]) ? @"empty" : _formFieldContent;
}

- (BOOL)setlastFocus {
    return _lastFocus ? _lastFocus : NO;
}

@end
