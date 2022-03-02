//
//  MIFormParameters.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import "MIFormParameters.h"
#import "MappIntelligenceLogger.h"

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

#if !TARGET_OS_WATCH
@property NSMutableArray<UITextField *> * textFields;
@property NSMutableArray<UITextView *> * textViews;
@property NSMutableArray<UISwitch *> * switches;
@property NSMutableArray<UIPickerView *> * pickers;
#endif

@property NSMutableArray<MIFormField *> * emptyNonPathFields;
@property NSMutableArray<MIFormField *> * filledNonPathFields;
@property NSMutableArray<MIFormField *> * pathFields;

@property (nullable) NSArray<MIFormField*>* fields;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
#if !TARGET_OS_WATCH
        _textFields = [[NSMutableArray alloc] init];
        _textViews = [[NSMutableArray alloc] init];
        _switches = [[NSMutableArray alloc] init];
        _pickers = [[NSMutableArray alloc] init];
#endif
        //TODO: add watchOS controller name
        _formName = @"";
        _fieldIds = [[NSMutableArray alloc] init];
        _renameFields = [[NSMutableDictionary alloc] init];
        _changeFieldsValue = [[NSMutableDictionary alloc] init];
        _anonymousSpecificFields = [[NSMutableArray alloc] init];
        _fullContentSpecificFields = [[NSMutableArray alloc] init];
        _confirmButton = YES;
        _pathAnalysis = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setTrackableFields {
    if([_fieldIds count] > 0) {
#if !TARGET_OS_WATCH
        dispatch_sync(dispatch_get_main_queue(), ^{
            for (UITextField* textField in _textFields) {
                if (![[_fieldIds copy] containsObject:[NSNumber numberWithInteger:textField.tag]]) {
                    [_textFields removeObject:textField];
                }
            }
            for (UITextView* textView in _textViews) {
                if (![[_fieldIds copy] containsObject:[NSNumber numberWithInteger:textView.tag]]) {
                    [_textViews removeObject:textView];
                }
            }
            for (UIPickerView* pickerView in _pickers) {
                if (![[_fieldIds copy] containsObject:[NSNumber numberWithInteger:pickerView.tag]]) {
                    [_pickers removeObject:pickerView];
                }
            }
            for (UISwitch* switchC in [_switches copy]) {
                if (![[_fieldIds copy] containsObject:[NSNumber numberWithInteger:switchC.tag]]) {
                    [_switches removeObject:switchC];
                }
            }
        });
#endif
    }
}

#if !TARGET_OS_WATCH
-(NSString*)extractLabelFromPickerView: (UIView*) godView {
    if ([godView isKindOfClass:UILabel.class]) {
        return ((UILabel*)godView).text;
    }
    for (UIView* view in [godView subviews]) {
        if ([view isKindOfClass:UILabel.class]) {
            return ((UILabel*)view).text;
        } else {
            return [self extractLabelFromPickerView:view];
        }
    }
    return @"empty";
}

-(NSString* ) extractValueForAllComponentOfPickerView: (UIPickerView*) pickerView {
    NSString* pickerString = @"";
    NSInteger numberOfComponents = [pickerView numberOfComponents];
    for (int i = 0; i < numberOfComponents; i++)
    {
        NSLog(@"%@", pickerView.subviews.firstObject.subviews.lastObject);
        NSInteger selectedRow = [pickerView selectedRowInComponent:i];
        UIView* selectedView = [pickerView viewForRow:selectedRow forComponent:i];
        if (selectedView == NULL) {
            selectedView = pickerView.subviews.firstObject.subviews[i].subviews.lastObject;
        }
        if([pickerString isEqualToString:@""]) {
            pickerString = [[NSString alloc] initWithFormat:@"%@", [self extractLabelFromPickerView:selectedView]];
        } else {
            pickerString = [[NSString alloc] initWithFormat:@"%@/%@", pickerString, [self extractLabelFromPickerView:selectedView]];
        }
    }
    return pickerString;
}
#endif

- (void)createFromFields {
#if !TARGET_OS_WATCH
    UIViewController* superViewController = self.topViewController;
    dispatch_sync(dispatch_get_main_queue(), ^{
        __block UIView* superView = superViewController.view;
        if (superView) {
            //make sure that arrays are empty, if property is saved as state at SwiftUI app
            _textFields = [[NSMutableArray alloc] init];
            _textViews = [[NSMutableArray alloc] init];
            _switches = [[NSMutableArray alloc] init];
            _pickers = [[NSMutableArray alloc] init];
            [self getTextFields:superView];
            [self getTextViews:superView];
            [self getPickerViews:superView];
            [self getSwithces:superView];
        }
    });
    _formName = NSStringFromClass(self.topViewController.classForCoder);
#endif
    _fields = [[NSMutableArray alloc] init];
    [self setTrackableFields];
#if !TARGET_OS_WATCH
    for (UITextField* textField in _textFields) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self->_fields = [self->_fields arrayByAddingObject:[[MIFormField alloc] initWithName:(textField.accessibilityLabel ? textField.accessibilityLabel : NSStringFromClass(textField.classForCoder)) andContent:textField.text andID:textField.tag andWithAnonymus:(_anonymous == nil) ? YES : [_anonymous boolValue] andFocus:textField.isFocused]];
        });
    }
    for (UITextView* textView in _textViews) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self->_fields = [self->_fields arrayByAddingObject:[[MIFormField alloc] initWithName:(textView.accessibilityLabel ? textView.accessibilityLabel : NSStringFromClass(textView.classForCoder)) andContent:textView.text andID:textView.tag andWithAnonymus:(_anonymous == nil) ? YES : [_anonymous boolValue] andFocus:textView.isFocused]];
        });
    }
    for (UIPickerView* pickerView in _pickers) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString* test = [self extractValueForAllComponentOfPickerView:pickerView];
            self->_fields = [self->_fields arrayByAddingObject:[[MIFormField alloc] initWithName:(pickerView.accessibilityLabel ? pickerView.accessibilityLabel : NSStringFromClass(pickerView.classForCoder)) andContent:test andID:pickerView.tag andWithAnonymus:[_anonymous boolValue] ? YES : NO andFocus:pickerView.isFocused]];
        });
    }
    for (UISwitch* switchC in _switches) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self->_fields = [self->_fields arrayByAddingObject:[[MIFormField alloc] initWithName:(switchC.accessibilityLabel ? switchC.accessibilityLabel : NSStringFromClass(switchC.classForCoder)) andContent:(switchC.on ? @"1" : @"0") andID:switchC.tag andWithAnonymus:[_anonymous boolValue] ? YES : NO andFocus:switchC.isFocused]];
        });
    }
#endif
    
    if (![_anonymous boolValue]) {
        for (MIFormField* field in _fields) {
            if ([_anonymousSpecificFields containsObject:[NSNumber numberWithInteger:(NSInteger)field.ID]]) {
                [[_fields objectAtIndex: [_fields indexOfObject:field]] setAnonymus:YES];
            }
        }
    }
    
    for (MIFormField* field in _fields) {
        if ([[_renameFields allKeys] containsObject:[NSNumber numberWithInteger:(NSInteger)field.ID]]) {
            [[_fields objectAtIndex: [_fields indexOfObject:field]] setFormFieldName:_renameFields[[NSNumber numberWithInteger:field.ID]]];
            
        }
        if ([[_changeFieldsValue allKeys] containsObject:[NSNumber numberWithInteger:(NSInteger)field.ID]] && ![_anonymous boolValue]) {
            [[_fields objectAtIndex: [_fields indexOfObject:field]] setFormFieldContent:_changeFieldsValue[[NSNumber numberWithInteger:(NSInteger)field.ID]]];
        }
        if ([_fullContentSpecificFields containsObject:[NSNumber numberWithInteger:(NSInteger)field.ID]] && ![_anonymous boolValue]) {
            [[_fields objectAtIndex: [_fields indexOfObject:field]] setAnonymus:NO];
        }
    }
}

- (NSURLQueryItem *)asQueryItemsForPatyAnylisis {
    NSString* pathAnylisis = @"";
    //1. step
    // The first values are the fields that the user did not actively fill out, followed by the fields that the user did actively fill out.
    [self prepareFields];
    for (MIFormField* field in _emptyNonPathFields) {
        if([pathAnylisis isEqualToString:@""]) {
            pathAnylisis = [NSString stringWithFormat:@"%@", [field getFormFieldForQuery]];
        } else {
            pathAnylisis = [NSString stringWithFormat:@"%@;%@", pathAnylisis, [field getFormFieldForQuery]];
        }
    }
    for (MIFormField* field in _filledNonPathFields) {
        if([pathAnylisis isEqualToString:@""]) {
            pathAnylisis = [NSString stringWithFormat:@"%@", [field getFormFieldForQuery]];
        } else {
            pathAnylisis = [NSString stringWithFormat:@"%@;%@", pathAnylisis, [field getFormFieldForQuery]];
        }
    }
    //2. step
    //If a user navigated to a field multiple times, the field is tracked multiple times in the ft parameter
    for (MIFormField* field in _pathFields) {
        if([pathAnylisis isEqualToString:@""]) {
            pathAnylisis = [NSString stringWithFormat:@"%@", [field getFormFieldForQuery]];
        } else {
            pathAnylisis = [NSString stringWithFormat:@"%@;%@", pathAnylisis, [field getFormFieldForQuery]];
        }
    }
    return [[NSURLQueryItem alloc] initWithName:@"ft" value:pathAnylisis];
}

- (void)prepareFields {
    _emptyNonPathFields = [[NSMutableArray alloc] init];
    _filledNonPathFields = [[NSMutableArray alloc] init];
    _pathFields = [[NSMutableArray alloc] init];
    [self populatePathFields];
    for (MIFormField* field in _fields) {
        if(!field.formFieldContent && ![_pathAnalysis containsObject:[NSNumber numberWithInteger:field.ID]]) {
            [_emptyNonPathFields addObject:field];
        } else if(![_pathAnalysis containsObject:[NSNumber numberWithInteger:field.ID]]) {
            [_filledNonPathFields addObject:field];
        }
    }
}

- (void)populatePathFields {
    for (NSNumber* fieldID in _pathAnalysis) {
        NSUInteger index = [_fields indexOfObjectPassingTest:^BOOL(MIFormField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj.ID == [fieldID integerValue];
        }];
        [_pathFields addObject:[_fields objectAtIndex:index]];
    }
}


- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    [self createFromFields];
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"fn" value:[self getFormForQuery]]];
    [items addObject:[self asQueryItemsForPatyAnylisis]];
    return items;
}

- (NSString*)getFormForQuery {
    return [[NSString alloc] initWithFormat:@"%@|%i", _formName, _confirmButton];
}

#if !TARGET_OS_WATCH
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
        if ([view isKindOfClass:UITextView.class]) {
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
    __block UIWindow* window;
    dispatch_sync(dispatch_get_main_queue(), ^{
        window = [[UIApplication sharedApplication] keyWindow];
    });
    __block UIViewController* topViewControler;
    dispatch_sync(dispatch_get_main_queue(), ^{
        topViewControler = [window rootViewController];
    });
    if (!window || !topViewControler)
        return NULL;
    dispatch_sync(dispatch_get_main_queue(), ^{
        while( [topViewControler presentedViewController] ) {
            topViewControler = [topViewControler presentedViewController];
        }
    });
    if ([topViewControler isKindOfClass:UINavigationController.class]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            topViewControler = ((UINavigationController*)topViewControler).topViewController;
        });
        return topViewControler;
    }
    return topViewControler;
}
#endif

@end
