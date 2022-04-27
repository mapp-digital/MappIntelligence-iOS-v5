//
//  MIFormParametersTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 26.4.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIFormParameters.h"

#define key_form_name @"form_name"
#define key_field_ids @"field_ids"
#define key_rename_ids @"rename_ids"
#define key_change_fields_value @"change_fields_value"
#define key_anonymous_specific_fields @"anonymous_specific_fields"
#define key_full_content_specific_fields @"full_content_specific_fields"
#define key_confirm_button @"confirm_button"
#define key_anonymous @"anonymous"
#define key_path_analysis @"path_analysis"

#define key_form_submit @"mi_form_submit"
#define key_form_fields @"mi_form_fields"

@interface MIFormParametersTest : XCTestCase

@property NSString* formName;
@property NSMutableArray<NSNumber*>* fieldIds;
@property NSMutableDictionary* renameFields;
@property NSMutableDictionary* changeFieldsValue;
@property NSMutableArray<NSNumber*>* anonymousSpecificFields;
@property NSMutableArray<NSNumber*>* fullContentSpecificFields;
@property BOOL confirmButton;
@property NSNumber* anonymous;
@property NSMutableArray<NSNumber*>* pathAnalysis;

@property MIFormParameters* parameters;
@property MIFormParameters* parametersFromDictionary;
@property NSDictionary* dictionary;

@end

@implementation MIFormParametersTest

- (void)setUp {
    [self setUpDictiponary];
    _parameters = [[MIFormParameters alloc] init];
    _parameters.formName = _formName;
    _parameters.fieldIds = _fieldIds;
    _parameters.changeFieldsValue = _changeFieldsValue;
    _parameters.anonymousSpecificFields = _anonymousSpecificFields;
    _parameters.renameFields = _renameFields;
    _parameters.fullContentSpecificFields = _fullContentSpecificFields;
    _parameters.anonymous = _anonymous;
    _parameters.confirmButton = _confirmButton;
    _parameters.pathAnalysis = _pathAnalysis;
    _parametersFromDictionary = [[MIFormParameters alloc] initWithDictionary:_dictionary];
}

- (void)setUpDictiponary {
    _formName = @"testFormName";
    _fieldIds = [@[@1, @2] copy];
    _renameFields = [@{@1: @"renameField1"} copy];
    _changeFieldsValue = [@{@2: @"changeNameField2"} copy];
    _anonymousSpecificFields = [@[@3, @4] copy];
    _fullContentSpecificFields = [@[@4] copy];
    _confirmButton = YES;
    _anonymous = [NSNumber numberWithBool:NO];
    _pathAnalysis = [@[@1, @2, @2, @4] copy];
    
    _dictionary = @{key_form_name: _formName, key_field_ids: _fieldIds, key_rename_ids: _renameFields, key_change_fields_value: _changeFieldsValue, key_anonymous_specific_fields: _anonymousSpecificFields, key_full_content_specific_fields: _fullContentSpecificFields, key_confirm_button: [NSNumber numberWithBool:_confirmButton], key_anonymous: _anonymous, key_path_analysis: _pathAnalysis};
}

-(void) checkParameters: (MIFormParameters*)tmpParameters {
    XCTAssertTrue([tmpParameters.formName isEqualToString:_formName], @"Parameters has no good name property!" );
    XCTAssertTrue([tmpParameters.fieldIds isEqualToArray:_fieldIds], @"Parameters has no good fileds ids  property!" );
    XCTAssertTrue([tmpParameters.renameFields isEqualToDictionary:_renameFields], @"Parameters has no good rename fields value property!" );
    XCTAssertTrue([tmpParameters.changeFieldsValue isEqualToDictionary:_changeFieldsValue], @"Parameters has no good change fields values property!" );
    XCTAssertTrue([tmpParameters.anonymousSpecificFields isEqualToArray:_anonymousSpecificFields], @"Parameters has no good anonymous specific fields property!" );
    XCTAssertTrue([tmpParameters.fullContentSpecificFields isEqualToArray:_fullContentSpecificFields], @"Parameters has no good full content fields property!" );
    XCTAssertTrue([tmpParameters.anonymous isEqualToNumber:_anonymous], @"Parameters has no good anonymous property!" );
    XCTAssertTrue(tmpParameters.confirmButton == _confirmButton, @"Parameters has no good confirm button property!" );
    XCTAssertTrue([tmpParameters.pathAnalysis isEqualToArray:_pathAnalysis], @"Parameters has no good path property!" );
}

- (void)tearDown {
    _dictionary = NULL;
    _parameters = NULL;
    _parametersFromDictionary = NULL;
}

- (void)testInit {
    [self checkParameters:_parameters];
}

- (void)testInitFromDicitionary {
    [self checkParameters:_parametersFromDictionary];
}

@end
