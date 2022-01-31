//
//  MIFormParameters.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

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

@interface MIFormParameters()

@property NSMutableArray<UITextField *> * textFields;
@property NSMutableArray<UITextView *> * textViews;
@property NSMutableArray<UISwitch *> * switches;
@property NSMutableArray<UIPickerView *> * pickers;

@end

@implementation MIFormParameters

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        _formName = dictionary[key_form_name];
        _fieldIds = dictionary[key_field_ids];
        _renameFields = dictionary[key_rename_ids];
        _changeFieldsValue = dictionary[key_change_fields_value];
        _anonymousSpecificFields = dictionary[key_anonymous_specific_fields];
        _fullContentSpecificFields = dictionary[key_full_content_specific_fields];
        _confirmButton = dictionary[key_confirm_button];
        _anonymous = dictionary[key_anonymous];
        _pathAnalysis = dictionary[key_path_analysis];
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
- (instancetype)initWithController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        UIView* superView = [controller view];
        [self getTextFields:superView];
        [self getTextViews:controller.view];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView* superView = self.topViewController.view;
        if (superView) {
            [self getTextFields:superView];
            [self getTextViews:superView];
            [self getPickerViews:superView];
            [self getSwithces:superView];
            _formName = NSStringFromClass(self.topViewController.classForCoder);
            _fieldIds = [[NSMutableArray alloc] init];
            _renameFields = [[NSMutableDictionary alloc] init];
            _changeFieldsValue = [[NSMutableDictionary alloc] init];
            _anonymousSpecificFields = [[NSMutableArray alloc] init];
            _fullContentSpecificFields = [[NSMutableArray alloc] init];
            _confirmButton = YES;
            _anonymous = NO;
            _pathAnalysis = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)setFieldIds:(NSMutableArray<NSNumber *> *)fieldIds {
    _fieldIds = fieldIds;
    if([fieldIds count] > 0) {
        for (UITextField* textField in _textFields) {
            if ([fieldIds containsObject:[NSNumber numberWithInteger:textField.tag]]) {
                [_textFields removeObject:textField];
            }
        }
        for (UITextView* textView in _textViews) {
            if ([fieldIds containsObject:[NSNumber numberWithInteger:textView.tag]]) {
                [_textViews removeObject:textView];
            }
        }
        for (UIPickerView* pickerView in _pickers) {
            if ([fieldIds containsObject:[NSNumber numberWithInteger:pickerView.tag]]) {
                [_pickers removeObject:pickerView];
            }
        }
        for (UISwitch* switchC in _switches) {
            if ([fieldIds containsObject:[NSNumber numberWithInteger:switchC.tag]]) {
                [_switches removeObject:switchC];
            }
        }
    }
}

- (void)createFromFields {
    _fields = [[NSMutableArray alloc] init];
    for (UITextField* textField in _textFields) {
        _fields = [_fields arrayByAddingObject:[[MIFormField alloc] initWithName:(textField.accessibilityLabel ? textField.accessibilityLabel : NSStringFromClass(textField.classForCoder)) andContent:textField.text andID:(NSInteger*)textField.tag andWithAnonymus:YES]];
    }
    for (UITextView* textView in _textViews) {
        _fields = [_fields arrayByAddingObject:[[MIFormField alloc] initWithName:(textView.accessibilityLabel ? textView.accessibilityLabel : NSStringFromClass(textView.classForCoder)) andContent:textView.text andID:(NSInteger*)textView.tag andWithAnonymus:YES]];
    }
    for (UIPickerView* pickerView in _pickers) {
        _fields = [_fields arrayByAddingObject:[[MIFormField alloc] initWithName:(pickerView.accessibilityLabel ? pickerView.accessibilityLabel : NSStringFromClass(pickerView.classForCoder)) andContent:pickerView andID:(NSInteger*)pickerView.tag andWithAnonymus:NO]];
    }
    for (UISwitch* switchC in _switches) {
        _fields = [_fields arrayByAddingObject:[[MIFormField alloc] initWithName:(switchC.accessibilityLabel ? switchC.accessibilityLabel : NSStringFromClass(switchC.classForCoder)) andContent:(switchC.on ? @"1" : @"0") andID:(NSInteger*)switchC.tag andWithAnonymus:NO]];
    }
    
    if (!_anonymous) {
        for (MIFormField* field in _fields) {
            if ([_anonymousSpecificFields containsObject:[NSNumber numberWithInteger:*(NSInteger*)field.ID]]) {
                [[_fields objectAtIndex: [_fields indexOfObject:field]] setAnonymus:YES];
            }
        }
    }
    
    for (MIFormField* field in _fields) {
        if ([[_renameFields allKeys] containsObject:[NSNumber numberWithInteger:*(NSInteger*)field.ID]]) {
            [[_fields objectAtIndex: [_fields indexOfObject:field]] setFormFieldName:[_renameFields valueForKey: [[NSNumber numberWithInteger:*(NSInteger*)field.ID] stringValue] ]];
        }
        if ([[_changeFieldsValue allKeys] containsObject:[NSNumber numberWithInteger:*(NSInteger*)field.ID]]) {
            [[_fields objectAtIndex: [_fields indexOfObject:field]] setFormFieldContent:[_changeFieldsValue valueForKey: [[NSNumber numberWithInteger:*(NSInteger*)field.ID] stringValue] ]];
        }
        if ([_fullContentSpecificFields containsObject:[NSNumber numberWithInteger:*(NSInteger*)field.ID]]) {
            [[_fields objectAtIndex: [_fields indexOfObject:field]] setAnonymus:NO];
        }
    }
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
    return [[NSString alloc] initWithFormat:@"%@|%i", _formName, _confirmButton];
}

- (NSArray<UITextField *> *)getTextFields: (UIView*) mainView {
    for (UIView* view in [mainView subviews]) {
        if ([view isKindOfClass:UITextField.class]) {
            [_textFields addObject:(UITextField *)view];
        } else {
            [self getTextFields: view];
        }
    }
    return NULL;
}

- (NSArray<UITextView *> *)getTextViews: (UIView*) mainView {
    for (UIView* view in [mainView subviews]) {
        if ([view isKindOfClass:UITextField.class]) {
            [_textViews addObject:(UITextView *)view];
        } else {
            [self getTextViews: view];
        }
    }
    return NULL;
}

- (NSArray<UISwitch *> *)getSwithces: (UIView*) mainView {
    for (UIView* view in [mainView subviews]) {
        if ([view isKindOfClass:UISwitch.class]) {
            [_switches addObject:(UISwitch *)view];
        } else {
            [self getSwithces: view];
        }
    }
    return NULL;
}

- (NSArray<UIPickerView *> *)getPickerViews: (UIView*) mainView {
    for (UIView* view in [mainView subviews]) {
        if ([view isKindOfClass:UIPickerView.class]) {
            [_pickers addObject:(UIPickerView *)view];
        } else {
            [self getPickerViews: view];
        }
    }
    return NULL;
}

- (UIViewController*)topViewController {
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    UIViewController* topViewControler = [window rootViewController];
    if (!window || !topViewControler)
        return NULL;
    while( [topViewControler presentedViewController] ) {
        topViewControler = [topViewControler presentedViewController];
    }
    return topViewControler;
}

@end