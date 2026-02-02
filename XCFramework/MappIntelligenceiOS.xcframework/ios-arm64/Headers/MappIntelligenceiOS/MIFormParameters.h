//
//  MIFormParameters.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIFormParameters : NSObject

/// formName by default is name of uiviewcontroler, but user can specify it to be differnt one.
@property (nonatomic, nullable) NSString* formName;

/// fieldIds indicate ids which will be trackable, if it is not specified all trackable controls at form will be tracked
@property (nonatomic, nullable) NSMutableArray<NSNumber*>* fieldIds;

///  By default, the name of the field ID is used to generate the name of the field. If you want to change the default name you can specify this here.
@property (nonatomic, nullable) NSMutableDictionary* renameFields;

/// By default, the value of the text field is used as the value of the field. You can change the default value here. Please be aware that if hardcoded, the field value is changed permanently and does not indicate anymore if a field was left empty.
@property (nonatomic, nullable) NSMutableDictionary* changeFieldsValue;

///  By default, only EditText fields are anonymized and send as filled out or empty to the track server, instead of displaying the actual value of the field. If other field types need to be anonymized, you can indicate them here.
@property (nonatomic, nullable) NSMutableArray<NSNumber*>* anonymousSpecificFields;

/// By default, the SDK sends EditText fields anonymized (filled out / empty) to Mapp Intelligence. If you want to send the actual content of the specific fields instead, indicate them here.
@property (nonatomic, nullable) NSMutableArray<NSNumber*>* fullContentSpecificFields;

///  If you want to indicate that a form has been submitted or canceled, you can set the confirmButton to true or false. By default, the confirmButton is set to true.
@property (nonatomic) BOOL confirmButton;

/// If you want to anonymize all field types, set anonymous to true.
@property (nonatomic, nullable) NSNumber* anonymous;

/// You can track the order in which the user has filled out the fields. Please note that you need to track the order manually and parse the data to the fieldsOrder function. Mapp Intelligence cannot track the order in which the user filled out the form automatically.
@property (nonatomic, nullable) NSMutableArray<NSNumber*>* pathAnalysis;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
