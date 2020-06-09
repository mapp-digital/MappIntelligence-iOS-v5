//
//  DatabaseManager.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 09/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

typedef void(^StorageManagerCompletionHandler)(NSError *error, id data);

@end

NS_ASSUME_NONNULL_END
