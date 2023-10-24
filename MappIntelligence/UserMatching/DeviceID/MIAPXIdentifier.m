//
//  APXIdentifier.m
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 6/2/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#import "MIAPXIdentifier.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import "MIKeychainManager.h"

NSString *const MISUUIDDefaultIdentifier   = @"00000000-0000-0000-0000-000000000000";
NSString *const MISUUIDTypeDataDictionary  = @"public.AppSecureUDID";
NSString *const MISUUIDTimeStampKey        = @"SUUIDTimeStampKey";
NSString *const MISUUIDOwnerKey            = @"SUUIDOwnerKey";
NSString *const MISUUIDLastAccessedKey     = @"SUUIDLastAccessedKey";
NSString *const MISUUIDIdentifierKey       = @"SUUIDIdentifierKey";
NSString *const MISUUIDOptOutKey           = @"SUUIDOptOutKey";
NSString *const MISUUIDModelHashKey        = @"SUUIDModelHashKey";
NSString *const MISUUIDSchemaVersionKey    = @"SUUIDSchemaVersionKey";
NSString *const MISUUIDPastboardFileFormat = @"org.AppSecureUDID-";

#define SUUID_SCHEMA_VERSION (1)
#define SUUID_MAX_STORAGE_LOCATIONS (64)
#define SECURE_UUID_KEY @"com-appoxee-lib-uuid-ios-devices"

@implementation MIAPXIdentifier

+ (NSString *)UDIDForDomain:(NSString *)domain usingKey:(NSString *)key
{
    NSString *identifier = MISUUIDDefaultIdentifier;
    NSString* bundleID = [NSString stringWithFormat:@"%@.AppSecureUDID", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
    if (@available(iOS 14, *)) {
        NSString* keyChainIdentifier = [[MIKeychainManager default] loadObjectForKey:bundleID];
        if (keyChainIdentifier) {
            return keyChainIdentifier;
        }
    }
    
    // Salt the domain to make the crypt keys affectively unguessable.
    NSData *domainAndKey = [[NSString stringWithFormat:@"%@%@", domain, key] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ownerKey      = MISUUIDHash(domainAndKey);
    
    // Encrypt the salted domain key and load the pasteboard on which to store data
    NSData *encryptedOwnerKey = MISUUIDCryptorToData(kCCEncrypt, [domain dataUsingEncoding:NSUTF8StringEncoding], ownerKey);
    
    // @synchronized introduces an implicit @try-@finally, so care needs to be taken with the return value
    @synchronized (self) {
        NSMutableDictionary *topLevelDictionary = nil;
        
        // Retrieve an appropriate storage index for this owner
        NSInteger ownerIndex = MISUUIDStorageLocationForOwnerKey(encryptedOwnerKey, &topLevelDictionary);
        
        // If the model hash key is present, verify it, otherwise add it
        NSData *storedModelHash = [topLevelDictionary objectForKey:MISUUIDModelHashKey];
        NSData *modelHash       = MISUUIDModelHash();
        
        if (storedModelHash) {
            if (![modelHash isEqual:storedModelHash]) {
                // The model hashes do not match - this structure is invalid
                [topLevelDictionary removeAllObjects];
            }
        }
        
        // store the current model hash
        [topLevelDictionary setObject:modelHash forKey:MISUUIDModelHashKey];
        
        // check for the opt-out flag and return the default identifier if we find it
        if ([[topLevelDictionary objectForKey:MISUUIDOptOutKey] boolValue] == YES) {
            return identifier;
        }
        
        // If we encounter a schema version greater than we support, there is no simple alternative
        // other than to simulate Opt Out.  Any writes to the store risk corruption.
        if ([[topLevelDictionary objectForKey:MISUUIDSchemaVersionKey] intValue] > SUUID_SCHEMA_VERSION) {
            return identifier;
        }
        
        // Attempt to get the owner's dictionary.  Should we get back nil from the encryptedDomain key, we'll still
        // get a valid, empty mutable dictionary
        NSMutableDictionary *ownerDictionary = [NSMutableDictionary dictionaryWithDictionary:[topLevelDictionary objectForKey:encryptedOwnerKey]];
        
        // Set our last access time and claim ownership for this storage location.
        NSDate* lastAccessDate = [NSDate date];
        
        [ownerDictionary    setObject:lastAccessDate    forKey:MISUUIDLastAccessedKey];
        [topLevelDictionary setObject:lastAccessDate    forKey:MISUUIDTimeStampKey];
        [topLevelDictionary setObject:encryptedOwnerKey forKey:MISUUIDOwnerKey];
        
        [topLevelDictionary setObject:[NSNumber numberWithInt:SUUID_SCHEMA_VERSION] forKey:MISUUIDSchemaVersionKey];
        
        // Make sure our owner dictionary is in the top level structure
        [topLevelDictionary setObject:ownerDictionary forKey:encryptedOwnerKey];
        
        
        NSData *identifierData = [ownerDictionary objectForKey:MISUUIDIdentifierKey];
        if (identifierData) {
            identifier = MISUUIDCryptorToString(kCCDecrypt, identifierData, ownerKey);
            if (!identifier) {
                // We've failed to decrypt our identifier.  This is a sign of storage corruption.

                MISUUIDDeleteStorageLocation(ownerIndex);
                
                // return here - do not write values back to the store
                return MISUUIDDefaultIdentifier;
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
            NSData *data = MISUUIDCryptorToData(kCCEncrypt, [identifier dataUsingEncoding:NSUTF8StringEncoding], ownerKey);
            
            [ownerDictionary setObject:data forKey:MISUUIDIdentifierKey];
        }
        if (@available(iOS 14, *)) {
            [[MIKeychainManager default] saveObject:identifier forKey:bundleID];
        } else {
            MISUUIDWriteDictionaryToStorageLocation(ownerIndex, topLevelDictionary);
        }
    }
    
    return identifier;
}

/*
 Compute a SHA1 of the input.
 */
NSData *MISUUIDHash(NSData __unsafe_unretained *data) {
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSData *dataOutput = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    
    return dataOutput;
}

/*
 Applies the operation (encrypt or decrypt) to the NSData value with the provided NSData key
 and returns the value as NSData.
 */
NSData *MISUUIDCryptorToData(CCOperation operation, NSData *value, NSData *key) {
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
NSInteger MISUUIDStorageLocationForOwnerKey(NSData *ownerKey, NSMutableDictionary** ownerDictionary) {
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
        dictionary = MISUUIDDictionaryForStorageLocation(i);
        if (!dictionary) {
            if (lowestUnusedIndex == -1) {
                lowestUnusedIndex = i;
            }
            
            continue;
        }
        
        // Check the 'modified' timestamp of this pasteboard
        modifiedDate = [dictionary valueForKey:MISUUIDTimeStampKey];
        optedOut     = optedOut || [[dictionary valueForKey:MISUUIDOptOutKey] boolValue];
        
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
        if ([[dictionary objectForKey:MISUUIDOwnerKey] isEqual:ownerKey]) {
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
        [*ownerDictionary setObject:[NSNumber numberWithBool:YES] forKey:MISUUIDOptOutKey];
    }
    
    // Make sure to write the most recent structure to the new location
    MISUUIDWriteDictionaryToStorageLocation(ownerIndex, mostRecentDictionary);
    return ownerIndex;
}

NSData* MISUUIDModelHash(void) {
    
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
    
    NSData *data = MISUUIDHash([result dataUsingEncoding:NSUTF8StringEncoding]);
    
    free(value);
    
    result = nil;
    
    return data;
}

/*
 Applies the operation (encrypt or decrypt) to the NSData value with the provided NSData key
 and returns the value as an NSString.
 */
NSString *MISUUIDCryptorToString(CCOperation operation, NSData *value, NSData *key) {
    NSData* data;
    
    data = MISUUIDCryptorToData(operation, value, key);
    if (!data) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/*
Clear a storage location, removing anything stored there.  Useful for dealing with
potential corruption.  Be careful with this function, as it can remove Opt-Out markers.
*/
void MISUUIDDeleteStorageLocation(NSInteger number) {
    UIPasteboard* pasteboard;
    NSString*     name;
    
    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return;
    }
    
    name       = MISUUIDPasteboardNameForNumber(number);
    pasteboard = [UIPasteboard pasteboardWithName:name create:NO];
    if (!pasteboard)
        return;
    
    // While setting pasteboard data to nil seems to always remove contents, the
    // removePasteboardWithName: call doesn't appear to always work.  Using both seems
    // like the safest thing to do
    [pasteboard setData:[[NSData alloc] init] forPasteboardType:MISUUIDTypeDataDictionary];
    [UIPasteboard removePasteboardWithName:name];
}

/*
 Writes out a dictionary to a storage location.  That dictionary must be a 'valid'
 AppSecureUDID structure, and the location must be within range.  A new location is
 created if is didn't already exist.
 */
void MISUUIDWriteDictionaryToStorageLocation(NSInteger number, NSDictionary* dictionary) {
    UIPasteboard* pasteboard;
    
    // be sure to respect our limits
    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return;
    }
    
    // only write out valid structures
    if (!MISUUIDValidTopLevelObject(dictionary)) {
        return;
    }
    
    pasteboard = [UIPasteboard pasteboardWithName:MISUUIDPasteboardNameForNumber(number) create:YES];
    if (!pasteboard) {
        return;
    }
        
    NSError * error = nil;
    [pasteboard setData:[NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:NO error:&error] forPasteboardType:MISUUIDTypeDataDictionary];
}

/*
 Reads a dictionary from a storage location.  Validation occurs once data
 is read, but before it is returned.  If something fails, or if the read structure
 is invalid, the location is cleared.
 
 Returns the data dictionary, or nil on failure.
 */
NSDictionary *MISUUIDDictionaryForStorageLocation(NSInteger number) {
    id            decodedObject;
    UIPasteboard* pasteboard;
    NSData*       data;
    
    // Don't even bother if the index is outside our limits
    if (number < 0 || number >= SUUID_MAX_STORAGE_LOCATIONS) {
        return nil;
    }
    
    pasteboard = [UIPasteboard pasteboardWithName:MISUUIDPasteboardNameForNumber(number) create:NO];
    if (!pasteboard) {
        return nil;
    }
    
    data = [pasteboard valueForPasteboardType:MISUUIDTypeDataDictionary];

    if (!data) {
        return nil;
    }
    
    @try {
        NSError * error = nil;
        
        decodedObject = [NSKeyedUnarchiver unarchivedObjectOfClass: [NSArray class] fromData:data error:&error];
    } @catch (NSException* exception) {
        // Catching an exception like this is risky.   However, crashing here is
        // not acceptable, and unarchiveObjectWithData can throw.
        [pasteboard setData:[[NSData alloc] init] forPasteboardType:MISUUIDTypeDataDictionary];
        
        return nil;
    }
    
    if (!MISUUIDValidTopLevelObject(decodedObject)) {
        [pasteboard setData:[[NSData alloc] init] forPasteboardType:MISUUIDTypeDataDictionary];
        
        return nil;
    }
    
    return decodedObject;
}

/*
 Returns an NSString formatted with the supplied number.
 */
NSString *MISUUIDPasteboardNameForNumber(NSInteger number) {
    
    return [NSString stringWithFormat:@"%@%tu", MISUUIDPastboardFileFormat, number];
}

/*
 Attempts to validate the full AppSecureUDID structure.
 */
BOOL MISUUIDValidTopLevelObject(id object) {
    if (![object isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    // Now, we need to verify the current schema.  There are a few possible valid states:
    // - SUUIDTimeStampKey + SUUIDOwnerKey + at least one additional key that is not SUUIDOptOutKey
    // - SUUIDTimeStampKey + SUUIDOwnerKey + SUUIDOptOutKey
    
    if ([object objectForKey:MISUUIDTimeStampKey] && [object objectForKey:MISUUIDOwnerKey]) {
        NSMutableDictionary* ownersOnlyDictionary;
        NSData*              ownerField;
        
        if ([object objectForKey:MISUUIDOptOutKey]) {
            return YES;
        }
        
        // We have to trust future schema versions.  Note that the lack of a schema version key will
        // always fail this check, since the first schema version was 1.
        if ([[object objectForKey:MISUUIDSchemaVersionKey] intValue] > SUUID_SCHEMA_VERSION) {
            return YES;
        }
        
        ownerField = [object objectForKey:MISUUIDOwnerKey];
        if (![ownerField isKindOfClass:[NSData class]]) {
            return NO;
        }
        
        ownersOnlyDictionary = [NSMutableDictionary dictionaryWithDictionary:object];
        
        [ownersOnlyDictionary removeObjectForKey:MISUUIDTimeStampKey];
        [ownersOnlyDictionary removeObjectForKey:MISUUIDOwnerKey];
        [ownersOnlyDictionary removeObjectForKey:MISUUIDOptOutKey];
        [ownersOnlyDictionary removeObjectForKey:MISUUIDModelHashKey];
        [ownersOnlyDictionary removeObjectForKey:MISUUIDSchemaVersionKey];
        
        // now, iterate through to verify each internal structure
        for (id key in [ownersOnlyDictionary allKeys]) {
            if ([key isEqual:MISUUIDTimeStampKey] || [key isEqual:MISUUIDOwnerKey] || [key isEqual:MISUUIDOptOutKey])
                continue;
            
            if (![key isKindOfClass:[NSData class]]) {
                return NO;
            }
            
            if (!MISUUIDValidOwnerObject([ownersOnlyDictionary objectForKey:key])) {
                return NO;
            }
        }
        
        // if all these tests pass, this structure is valid
        return YES;
    }
    
    // Maybe just the SUUIDOptOutKey, on its own
    if ([[object objectForKey:MISUUIDOptOutKey] boolValue] == YES) {
        return YES;
    }
    
    return NO;
}

/*
 Attempts to validate the structure for an "owner dictionary".
 */
BOOL MISUUIDValidOwnerObject(id object) {
    
    if (![object isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    return [object valueForKey:MISUUIDLastAccessedKey] && [object valueForKey:MISUUIDIdentifierKey];
}

@end
