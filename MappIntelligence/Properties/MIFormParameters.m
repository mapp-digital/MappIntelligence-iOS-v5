//
//  MIFormParameters.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import "MIFormParameters.h"
#import <UIKit/UIKit.h>

#define key_form_name @"mi_form_name"
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
