//
//  Product.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSObject

@property (nonatomic, nullable) NSString* name;
@property (nonatomic, nullable) NSString* price;
@property (nonatomic, nullable) NSNumber* quantity;
//TODO: Do we need this here or at e-commerce properties? 
//@property (nullable) Status* status;
//@property (nullable) NSString* currencyCode;
//@property (nullable) NSString* orderNumber;
//@property (nullable) NSString* orderValue;

@end

NS_ASSUME_NONNULL_END
