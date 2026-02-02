//
//  MIFormField.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIFormField : NSObject

@property (nonatomic, nullable) NSString* formFieldName;
@property (nonatomic, nullable) NSString* formFieldContent;
@property (nonatomic) NSInteger ID;
@property (nonatomic) BOOL lastFocus;
@property (nonatomic) BOOL anonymus;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (instancetype)initWithName:(NSString*)name andContent: (NSString*)content andID: (NSInteger)ID andWithAnonymus:(BOOL)anonymus andFocus:(BOOL)focus;
-(void)renameField: (NSString*) renameValue;
- (NSString*)getFormFieldForQuery;

@end

NS_ASSUME_NONNULL_END
