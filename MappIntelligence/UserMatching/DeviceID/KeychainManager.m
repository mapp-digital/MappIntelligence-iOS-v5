//
//  KeychainManager.m
//  AppoxeeSDK
//
//  Created by Stefan Stevanovic on 22.9.21..
//  Copyright © 2021 Appoxee. All rights reserved.
//
#if !TARGET_OS_WATCH && !TARGET_OS_TV
#import "KeychainManager.h"
#import <Security/Security.h>
#import "APXInappLogger.h"


@implementation KeychainManager

+(KeychainManager*)default
{ static KeychainManager *keychainManager = nil;
    if(keychainManager == nil) {
        keychainManager = [[KeychainManager alloc] init];
    }
    return keychainManager;
}

- (BOOL)checkOSStatus:(OSStatus)status {
    return status == noErr;
}

- (NSMutableDictionary *)keychainQueryForKey:(NSString *)key {
    return [@{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
              (__bridge id)kSecAttrService : key,
              (__bridge id)kSecAttrAccount : key,
              (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock
              } mutableCopy];
}

- (BOOL)saveObject:(id)object forKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    // Deleting previous object with this key, because SecItemUpdate is more complicated.
    [self deleteObjectForKey:key];
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:(__bridge id)kSecValueData];
    return [self checkOSStatus:SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL)];
}

- (id)loadObjectForKey:(NSString *)key {
    id object = nil;
    
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if ([self checkOSStatus:SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData)]) {
        @try {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            [[APXInappLogger shared] logObj:[[NSString alloc] initWithFormat:@"Unarchiving for key %@ failed with exception %@", key, exception.name] forDescription:kAPXLogLevelDescriptionDebug];
            object = nil;
        }
        @finally {}
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return object;
}

- (BOOL)deleteObjectForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    return [self checkOSStatus:SecItemDelete((__bridge CFDictionaryRef)keychainQuery)];
}


@end
#endif
