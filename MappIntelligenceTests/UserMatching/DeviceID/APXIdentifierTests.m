//
//  APXIdentifierTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 04.09.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIAPXIdentifier.h"
#import "MIKeychainManager.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>

extern BOOL MISUUIDValidTopLevelObject(id object);
extern BOOL MISUUIDValidOwnerObject(id object);
extern NSString *MISUUIDPasteboardNameForNumber(NSInteger number);
extern NSData *MISUUIDHash(NSData *data);
extern NSData *MISUUIDCryptorToData(CCOperation operation, NSData *value, NSData *key);
extern NSString *MISUUIDCryptorToString(CCOperation operation, NSData *value, NSData *key);
extern NSData *MISUUIDModelHash(void);
extern NSInteger MISUUIDStorageLocationForOwnerKey(NSData *ownerKey, NSMutableDictionary **ownerDictionary);
extern void MISUUIDDeleteStorageLocation(NSInteger number);
extern void MISUUIDWriteDictionaryToStorageLocation(NSInteger number, NSDictionary *dictionary);
extern NSDictionary *MISUUIDDictionaryForStorageLocation(NSInteger number);

@interface MIAPXIdentifierTests : XCTestCase
@end

@implementation MIAPXIdentifierTests

- (void)tearDown {
    [[MIKeychainManager default] deleteObjectForKey:@"com.appoxee.lib-uuid-ios-devices"];
    [super tearDown];
}

- (void)testGenerateUDID {
    NSString *domain = @"com.example.app";
    NSString *key = @"test-key";

    NSString *generatedUUID = [MIAPXIdentifier UDIDForDomain:domain usingKey:key];

    XCTAssertNotNil(generatedUUID);
    XCTAssertEqual(generatedUUID.length, 36);
}

- (void)testGenerateUDIDIsValidForSameDomainAndKey {
    NSString *domain = @"com.example.app";
    NSString *key = @"test-key";

    NSString *first = [MIAPXIdentifier UDIDForDomain:domain usingKey:key];
    NSString *second = [MIAPXIdentifier UDIDForDomain:domain usingKey:key];

    XCTAssertNotNil(first);
    XCTAssertNotNil(second);
    XCTAssertEqual(first.length, 36);
    XCTAssertEqual(second.length, 36);
}

- (void)testValidTopLevelObjectRejectsNonDictionary {
    XCTAssertFalse(MISUUIDValidTopLevelObject(@"string"));
}

- (void)testValidTopLevelObjectAcceptsOptOutOnly {
    NSDictionary *dict = @{ @"SUUIDOptOutKey": @YES };
    XCTAssertTrue(MISUUIDValidTopLevelObject(dict));
}

- (void)testValidTopLevelObjectRejectsMissingOwnerType {
    NSDictionary *dict = @{
        @"SUUIDTimeStampKey": [NSDate date],
        @"SUUIDOwnerKey": @"notData"
    };
    XCTAssertFalse(MISUUIDValidTopLevelObject(dict));
}

- (void)testValidOwnerObjectRequiresFields {
    NSDictionary *owner = @{
        @"SUUIDLastAccessedKey": [NSDate date],
        @"SUUIDIdentifierKey": [NSData data]
    };
    XCTAssertTrue(MISUUIDValidOwnerObject(owner));
    XCTAssertFalse(MISUUIDValidOwnerObject(@{ @"SUUIDLastAccessedKey": [NSDate date] }));
}

- (void)testPasteboardNameForNumber {
    NSString *name = MISUUIDPasteboardNameForNumber(3);
    XCTAssertEqualObjects(name, @"org.AppSecureUDID-3");
}

- (void)testHashReturnsSha1Length {
    NSData *hash = MISUUIDHash([@"abc" dataUsingEncoding:NSUTF8StringEncoding]);
    XCTAssertEqual(hash.length, 20);
}

- (void)testCryptorToStringRoundTrip {
    NSData *key = MISUUIDHash([@"key" dataUsingEncoding:NSUTF8StringEncoding]);
    NSData *value = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];

    NSData *encrypted = MISUUIDCryptorToData(kCCEncrypt, value, key);
    NSString *decrypted = MISUUIDCryptorToString(kCCDecrypt, encrypted, key);

    XCTAssertEqualObjects(decrypted, @"hello");
}

- (void)testCryptorToStringReturnsNilWhenInvalidKey {
    NSData *value = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *decrypted = MISUUIDCryptorToString(kCCDecrypt, value, [NSData data]);

    XCTAssertNil(decrypted);
}

- (void)testWriteAndReadStorageLocation {
    NSInteger index = 2;
    NSData *ownerKey = [@"owner" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *ownerDictionary = @{
        @"SUUIDLastAccessedKey": [NSDate date],
        @"SUUIDIdentifierKey": [@"id" dataUsingEncoding:NSUTF8StringEncoding]
    };
    NSDictionary *topLevel = @{
        @"SUUIDTimeStampKey": [NSDate date],
        @"SUUIDOwnerKey": ownerKey,
        ownerKey: ownerDictionary
    };

    MISUUIDDeleteStorageLocation(index);
    MISUUIDWriteDictionaryToStorageLocation(index, topLevel);
    NSDictionary *readBack = MISUUIDDictionaryForStorageLocation(index);

    XCTAssertNotNil(readBack);
    XCTAssertNotNil(readBack[@"SUUIDOwnerKey"]);

    MISUUIDDeleteStorageLocation(index);
}

- (void)testReadStorageLocationReturnsNilForOutOfRange {
    NSDictionary *readBack = MISUUIDDictionaryForStorageLocation(-1);
    XCTAssertNil(readBack);
}

- (void)testDeleteStorageLocationOutOfRangeDoesNotCrash {
    MISUUIDDeleteStorageLocation(-1);
    MISUUIDDeleteStorageLocation(200);
}

- (void)testModelHashReturnsSha1Length {
    NSData *hash = MISUUIDModelHash();
    XCTAssertEqual(hash.length, 20);
}

- (void)testValidTopLevelObjectAcceptsHigherSchemaVersion {
    NSData *ownerKey = [@"owner" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *ownerDictionary = @{
        @"SUUIDLastAccessedKey": [NSDate date],
        @"SUUIDIdentifierKey": [@"id" dataUsingEncoding:NSUTF8StringEncoding]
    };
    NSDictionary *topLevel = @{
        @"SUUIDTimeStampKey": [NSDate date],
        @"SUUIDOwnerKey": ownerKey,
        @"SUUIDSchemaVersionKey": @2,
        ownerKey: ownerDictionary
    };

    XCTAssertTrue(MISUUIDValidTopLevelObject(topLevel));
}

- (void)testStorageLocationForOwnerKeyReturnsValidIndex {
    NSData *ownerKey = [@"owner-key" dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *ownerDictionary = nil;
    NSInteger index = MISUUIDStorageLocationForOwnerKey(ownerKey, &ownerDictionary);

    XCTAssertTrue(index >= 0);
    XCTAssertNotNil(ownerDictionary);
}

@end
