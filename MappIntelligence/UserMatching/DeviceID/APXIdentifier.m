//
//  APXIdentifier.m
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 6/2/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#if !TARGET_OS_WATCH && !TARGET_OS_TV
#import "APXIdentifier.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import "KeychainManager.h"

NSString *const SUUIDDefaultIdentifier   = @"00000000-0000-0000-0000-000000000000";
NSString *const SUUIDTypeDataDictionary  = @"public.AppSecureUDID";
NSString *const SUUIDTimeStampKey        = @"SUUIDTimeStampKey";
NSString *const SUUIDOwnerKey            = @"SUUIDOwnerKey";
NSString *const SUUIDLastAccessedKey     = @"SUUIDLastAccessedKey";
NSString *const SUUIDIdentifierKey       = @"SUUIDIdentifierKey";
NSString *const SUUIDOptOutKey           = @"SUUIDOptOutKey";
NSString *const SUUIDModelHashKey        = @"SUUIDModelHashKey";
NSString *const SUUIDSchemaVersionKey    = @"SUUIDSchemaVersionKey";
NSString *const SUUIDPastboardFileFormat = @"org.AppSecureUDID-";

#define SUUID_SCHEMA_VERSION (1)
#define SUUID_MAX_STORAGE_LOCATIONS (64)
#define SECURE_UUID_KEY @"com-appoxee-lib-uuid-ios-devices"

@implementation APXIdentifier

+ (NSString *)UDIDForDomain:(NSString *)domain usingKey:(NSString *)key
{
    NSString *identifier = SUUIDDefaultIdentifier;
    NSString* bundleID = [NSString stringWithFormat:@"%@.AppSecureUDID", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
    if (@available(iOS 14, *)) {
        NSString* keyChainIdentifier = [[KeychainManager default] loadObjectForKey:bundleID];
        if (keyChainIdentifier) {
            return keyChainIdentifier;
        }
    }
    
    // Salt the domain to make the crypt keys affectively unguessable.
    NSData *domainAndKey = [[NSString stringWithFormat:@"%@%@", domain, key] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ownerKey      = SUUIDHash(domainAndKey);
    
    // Encrypt the salted domain key and load the pasteboard on which to store data
    NSData *encryptedOwnerKey = SUUIDCryptorToData(kCCEncrypt, [domain dataUsingEncoding:NSUTF8StringEncoding], ownerKey);
    
    // @synchronized introduces an implicit @try-@finally, so care needs to be taken with the return value
    @synchronized (self) {
        NSMutableDictionary *topLevelDictionary = nil;
        
        // Retrieve an appropriate storage index for this owner
        NSInteger ownerIndex = SUUIDStorageLocationForOwnerKey(encryptedOwnerKey, &topLevelDictionary);
        
        // If the model hash key is present, verify it, otherwise add it
        NSData *storedModelHash = [topLevelDictionary objectForKey:SUUIDModelHashKey];
        NSData *modelHash       = SUUIDModelHash();
        
        if (storedModelHash) {
            if (![modelHash isEqual:storedModelHash]) {
                // The model hashes do not match - this structure is invalid
                [topLevelDictionary removeAllObjects];
            }
        }
        
        // store the current model hash
        [topLevelDictionary setObject:modelHash forKey:SUUIDModelHashKey];
        
        // check for the opt-out flag and return the default identifier if we find it
        if ([[topLevelDictionary objectForKey:SUUIDOptOutKey] boolValue] == YES) {
            return identifier;
        }
        
        // If we encounter a schema version greater than we support, there is no simple alternative
        // other than to simulate Opt Out.  Any writes to the store risk corruption.
        if ([[topLevelDictionary objectForKey:SUUIDSchemaVersionKey] intValue] > SUUID_SCHEMA_VERSION) {
            return identifier;
        }
        
        // Attempt to get the owner's dictionary.  Should we get back nil from the encryptedDomain key, we'll still
        // get a valid, empty mutable dictionary
        NSMutableDictionary *ownerDictionary = [NSMutableDictionary dictionaryWithDictionary:[topLevelDictionary objectForKey:encryptedOwnerKey]];
        
        // Set our last access time and claim ownership for this storage location.
        NSDate* lastAccessDate = [NSDate date];
        
        [ownerDictionary    setObject:lastAccessDate    forKey:SUUIDLastAccessedKey];
        [topLevelDictionary setObject:lastAccessDate    forKey:SUUIDTimeStampKey];
        [topLevelDictionary setObject:encryptedOwnerKey forKey:SUUIDOwnerKey];
        
        [topLevelDictionary setObject:[NSNumber numberWithInt:SUUID_SCHEMA_VERSION] forKey:SUUIDSchemaVersionKey];
        
        // Make sure our owner dictionary is in the top level structure
        [topLevelDictionary setObject:ownerDictionary forKey:encryptedOwnerKey];
        
        
        NSData *identifierData = [ownerDictionary objectForKey:SUUIDIdentifierKey];
        if (identifierData) {
            identifier = SUUIDCryptorToString(kCCDecrypt, identifierData, ownerKey);
            if (!identifier) {
                // We've failed to decrypt our identifier.  This is a sign of storage corruption.
                SUUIDDeleteStorageLocation(ownerIndex);
                
                // return here - do not write values back to the store
                return SUUIDDefaultIdentifier;
            }
        } else {
            // Otherwise, create a new RFC-4122 Version 4 UUID
            // http://en.wikipedia.org/wiki/Universally_unique_identifier
            
            if ([key isEqualToString:SECURE_UUID_KEY])
            {
                
                CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
                identifier = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
                CFRelease(uuid);
                
            }
            else
            {
                CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
                identifier = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
                CFRelease(uuid);
            }
            
            // Encrypt it for storage.
            NSData *data = SUUIDCryptorToData(kCCEncrypt, [identifier dataUsingEncoding:NSUTF8StringEncoding], ownerKey);
            
            [ownerDictionary setObject:data forKey:SUUIDIdentifierKey];
        }
        if (@available(iOS 14, *)) {
            [[KeychainManager default] saveObject:identifier forKey:bundleID];
        } else {
            SUUIDWriteDictionaryToStorageLocation(ownerIndex, topLevelDictionary);
        }
    }
    
    return identifier;
}

/*
 Compute a SHA1 of the input.
 */
NSData *SUUIDHash(NSData __unsafe_unretained *data) {
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSData *dataOutput = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    
    return dataOutput;
}

/*
 Applies the operation (encrypt or decrypt) to the NSData value with the provided NSData key
 and returns the value as NSData.
 */
NSData *SUUIDCryptorToData(CCOperation operation, NSData *value, NSData *key) {
    NSMutableData *output = [NSMutableData dataWithLength:value.length + kCCBlockSizeAES128];
    
    size_t numBytes = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],
                                          kCCKeySizeAES128,
                                          NULL,
                                          value.bytes,
                                          value.length,
                                          output.mutableBytes,
                                          output.length,
                                          &numBytes);
    
    if (cryptStatus == kCCSuccess) {
        return [[NSData alloc] initWithBytes:output.bytes length:numBytes];
    }
    
    return nil;
}

/*
 AppSecureUDID leverages UIPasteboards to persistently store its data.
 UIPasteboards marked as 'persistent' have the following attributes:
 - They persist across application relaunches, device reboots, and OS upgrades.
 - They are destroyed when the application that created them is deleted from the device.
 
 To protect against the latter case, AppSecureUDID leverages multiple pasteboards (up to
 SUUID_MAX_STORAGE_LOCATIONS), creating one for each distinct domain/app that
 leverages the system. The permanence of AppSecureUDIDs increases exponentially with the
 number of apps that use it.
 
 This function searches for a suitable storage location for a AppSecureUDID structure.  It
 attempts to find the structure written by ownerKey.  If no owner is found and there are
 still open locations, the lowest numbered location is selected.  If there are no
 available locations, the last-written is selected.
 
 Once a spot is found, the most-recent data is re-written over this location.  The location
 is then, finally, returned.
 */
NSInteger SUUIDStorageLocationForOwnerKey(NSData *ownerKey, NSMutableDictionary** ownerDictionary) {
    NSInteger     ownerIndex;
    NSInteger     lowestUnusedIndex;
    NSInteger     oldestUsedIndex;
    NSDate*       mostRecentDate;
    NSDate*       oldestUsedDate;
    NSDictionary* mostRecentDictionary;
    BOOL          optedOut;
    
    ownerIndex           = -1;
    lowestUnusedIndex    = -1;
    oldestUsedIndex      = 0;  // make sure this value is always in range
    mostRecentDate       = [NSDate distantPast];
    oldestUsedDate       = [NSDate distantFuture];
    mostRecentDictionary = nil;
    optedOut             = NO;
    
    // The array of AppSecureUDID pasteboards can be sparse, since any number of
    // apps may have been deleted. To find a pasteboard owned by the the current
    // domain, iterate all of them.
    for (NSInteger i = 0; i < SUUID_MAX_STORAGE_LOCATIONS; ++i) {
        NSDate*       modifiedDate;
        NSDictionary* dictionary;
        
        dictionary = SUUIDDictionaryForStorageLocation(i);
        if (!dictionary) {
            if (lowestUnusedIndex == -1) {
                lowestUnusedIndex = i;
            }
            
            continue;
        }
        
        // Check the 'modified' timestamp of this pasteboard
        modifiedDate = [dictionary valueForKey:SUUIDTimeStampKey];
        optedOut     = optedOut || [[dictionary valueForKey:SUUIDOptOutKey] boolValue];
        
        // Hold a copy of the data if this is the newest we've found so far.
        if ([modifiedDate compare:mostRecentDate] == NSOrderedDescending) {
            mostRecentDate       = modifiedDate;
            mostRecentDictionary = dictionary;
        }
        
        // Check for the oldest entry in the structure, used for eviction
        if ([modifiedDate compare:oldestUsedDate] == NSOrderedAscending) {
            oldestUsedDate  = modifiedDate;
            oldestUsedIndex = i;
        }
        
        // Finally, check if this is the pasteboard owned by the requesting domain.
        if ([[dictionary objectForKey:SUUIDOwnerKey] isEqual:ownerKey]) {
            ownerIndex = i;
        }
    }
    
    // If no pasteboard is owned by this domain, establish a new one to increase the
    // likelihood of permanence.
    if (ownerIndex == -1) {
        // Unless there are no available slots, then evict the oldest entry
        if ((lowestUnusedIndex < 0) || (lowestUnusedIndex >= SUUID_MAX_STORAGE_LOCATIONS)) {
            ownerIndex = oldestUsedIndex;
        } else {
            ownerIndex = lowestUnusedIndex;
        }
    }
    
    // pass back the dictionary, by reference
    *ownerDictionary = [NSMutableDictionary dictionaryWithDictionary:mostRecentDictionary];
    
    // make sure our Opt-Out flag is consistent
    if (optedOut) {
        [*ownerDictionary setObject:[NSNumber numberWithBool:YES] forKey:SUUIDOptOutKey];
    }
    
    // Make sure to write the most recent structure to the new location
    SUUIDWriteDictionaryToStorageLocation(ownerIndex, mostRecentDictionary);
    
    return ownerIndex;
}

NSData* SUUIDModelHash(void) {
    
    NSString *result = @"Unknown";
    char*  value;
    
    do {
        size_t size;
        
        value  = NULL;
        
        // first get the size
        if (sysctlbyname("hw.machine", NULL, &size, NULL, 0) != 0) {
            break;
        }
        
        value = malloc(size);
        
        if (!value) {
            
            break;
        }
        
        // now get the value
        if (sysctlbyname("hw.machine", value, &size, NULL, 0) != 0) {
            break;
        }
        
        // convert the value to an NSString
        result = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
        if (!result) {
            break;
        }
        
        // free our buffer
        
    } while (0);
    
    NSData *data = SUUIDHash([result dataUsingEncoding:NSUTF8StringEncoding]);
    
    free(value);
    
    result = nil;
    
    return data;
}

/*
 Applies the operation (encrypt or decrypt) to the NSData value with the provided NSData key
 and returns the value as an NSString.
 */
NSString *SUUIDCryptorToString(CCOperation operation, NSData *value, NSData *key) {
    NSData* data;
    
    data = SUUIDCryptorToData(operation, value, key);
    if (!data) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/*
Clear a storage location, removing anything stored there.  Useful for dealing with
potential corruption.  Be careful with this function, as it can remove Opt-Out markers.
*/
#if !TARGET_OS_WATCH && !TARGET_OS_TV
void SUUIDDeleteStorageLocation(NSInteger number) {
    UIPasteboard* pasteboard;
    NSString*     name;
    
    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return;
    }
    
    name       = SUUIDPasteboardNameForNumber(number);
    pasteboard = [UIPasteboard pasteboardWithName:name create:NO];
    if (!pasteboard)
        return;
    
    // While setting pasteboard data to nil seems to always remove contents, the
    // removePasteboardWithName: call doesn't appear to always work.  Using both seems
    // like the safest thing to do
    [pasteboard setData:[[NSData alloc] init] forPasteboardType:SUUIDTypeDataDictionary];
    [UIPasteboard removePasteboardWithName:name];
}
#endif

/*
 Writes out a dictionary to a storage location.  That dictionary must be a 'valid'
 AppSecureUDID structure, and the location must be within range.  A new location is
 created if is didn't already exist.
 */
#if !TARGET_OS_WATCH && !TARGET_OS_TV
void SUUIDWriteDictionaryToStorageLocation(NSInteger number, NSDictionary* dictionary) {
    UIPasteboard* pasteboard;
    
    // be sure to respect our limits
    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return;
    }
    
    // only write out valid structures
    if (!SUUIDValidTopLevelObject(dictionary)) {
        return;
    }
    
    pasteboard = [UIPasteboard pasteboardWithName:SUUIDPasteboardNameForNumber(number) create:YES];
    if (!pasteboard) {
        return;
    }
    
    pasteboard.persistent = YES;
    
    [pasteboard setData:[NSKeyedArchiver archivedDataWithRootObject:dictionary]
      forPasteboardType:SUUIDTypeDataDictionary];
}
#endif

/*
 Reads a dictionary from a storage location.  Validation occurs once data
 is read, but before it is returned.  If something fails, or if the read structure
 is invalid, the location is cleared.
 
 Returns the data dictionary, or nil on failure.
 */
#if !TARGET_OS_WATCH && !TARGET_OS_TV
NSDictionary *SUUIDDictionaryForStorageLocation(NSInteger number) {
    id            decodedObject;
    UIPasteboard* pasteboard;
    NSData*       data;
    
    // Don't even bother if the index is outside our limits
    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return nil;
    }
    
    pasteboard = [UIPasteboard pasteboardWithName:SUUIDPasteboardNameForNumber(number) create:NO];
    if (!pasteboard) {
        return nil;
    }
    
    data = [pasteboard valueForPasteboardType:SUUIDTypeDataDictionary];

    if (!data) {
        return nil;
    }
    
    @try {
        decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } @catch (NSException* exception) {
        // Catching an exception like this is risky.   However, crashing here is
        // not acceptable, and unarchiveObjectWithData can throw.
        [pasteboard setData:[[NSData alloc] init] forPasteboardType:SUUIDTypeDataDictionary];
        
        return nil;
    }
    
    if (!SUUIDValidTopLevelObject(decodedObject)) {
        [pasteboard setData:[[NSData alloc] init] forPasteboardType:SUUIDTypeDataDictionary];
        
        return nil;
    }
    
    return decodedObject;
}
#endif

/*
 Returns an NSString formatted with the supplied number.
 */
NSString *SUUIDPasteboardNameForNumber(NSInteger number) {
    
    return [NSString stringWithFormat:@"%@%tu", SUUIDPastboardFileFormat, number];
}

/*
 Attempts to validate the full AppSecureUDID structure.
 */
BOOL SUUIDValidTopLevelObject(id object) {
    if (![object isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    // Now, we need to verify the current schema.  There are a few possible valid states:
    // - SUUIDTimeStampKey + SUUIDOwnerKey + at least one additional key that is not SUUIDOptOutKey
    // - SUUIDTimeStampKey + SUUIDOwnerKey + SUUIDOptOutKey
    
    if ([object objectForKey:SUUIDTimeStampKey] && [object objectForKey:SUUIDOwnerKey]) {
        NSMutableDictionary* ownersOnlyDictionary;
        NSData*              ownerField;
        
        if ([object objectForKey:SUUIDOptOutKey]) {
            return YES;
        }
        
        // We have to trust future schema versions.  Note that the lack of a schema version key will
        // always fail this check, since the first schema version was 1.
        if ([[object objectForKey:SUUIDSchemaVersionKey] intValue] > SUUID_SCHEMA_VERSION) {
            return YES;
        }
        
        ownerField = [object objectForKey:SUUIDOwnerKey];
        if (![ownerField isKindOfClass:[NSData class]]) {
            return NO;
        }
        
        ownersOnlyDictionary = [NSMutableDictionary dictionaryWithDictionary:object];
        
        [ownersOnlyDictionary removeObjectForKey:SUUIDTimeStampKey];
        [ownersOnlyDictionary removeObjectForKey:SUUIDOwnerKey];
        [ownersOnlyDictionary removeObjectForKey:SUUIDOptOutKey];
        [ownersOnlyDictionary removeObjectForKey:SUUIDModelHashKey];
        [ownersOnlyDictionary removeObjectForKey:SUUIDSchemaVersionKey];
        
        // now, iterate through to verify each internal structure
        for (id key in [ownersOnlyDictionary allKeys]) {
            if ([key isEqual:SUUIDTimeStampKey] || [key isEqual:SUUIDOwnerKey] || [key isEqual:SUUIDOptOutKey])
                continue;
            
            if (![key isKindOfClass:[NSData class]]) {
                return NO;
            }
            
            if (!SUUIDValidOwnerObject([ownersOnlyDictionary objectForKey:key])) {
                return NO;
            }
        }
        
        // if all these tests pass, this structure is valid
        return YES;
    }
    
    // Maybe just the SUUIDOptOutKey, on its own
    if ([[object objectForKey:SUUIDOptOutKey] boolValue] == YES) {
        return YES;
    }
    
    return NO;
}

/*
 Attempts to validate the structure for an "owner dictionary".
 */
BOOL SUUIDValidOwnerObject(id object) {
    
    if (![object isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    return [object valueForKey:SUUIDLastAccessedKey] && [object valueForKey:SUUIDIdentifierKey];
}

@end
#endif
