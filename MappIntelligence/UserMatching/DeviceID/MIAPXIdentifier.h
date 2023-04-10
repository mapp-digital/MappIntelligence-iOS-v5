//
//  APXIdentifier.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 6/2/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIAPXIdentifier : NSObject

// class generates a device ID and was migrated form SDK 3.x

+ (NSString *)UDIDForDomain:(NSString *)domain usingKey:(NSString *)key;

@end
