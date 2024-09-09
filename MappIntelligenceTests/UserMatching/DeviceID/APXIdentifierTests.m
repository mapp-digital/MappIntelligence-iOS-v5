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

@interface MIAPXIdentifierTests : XCTestCase
@end

@implementation MIAPXIdentifierTests

- (void)setUp {
    [super setUp];
    // Inicijalizacija pre svakog testa
}

- (void)tearDown {
    // Čišćenje posle svakog testa
    [[MIKeychainManager default] deleteObjectForKey:@"com.appoxee.lib-uuid-ios-devices"];
    [super tearDown];
}

// Test generisanja UUID-a
- (void)testGenerateUDID {
    NSString *domain = @"com.example.app";
    NSString *key = @"test-key";
    
    NSString *generatedUUID = [MIAPXIdentifier UDIDForDomain:domain usingKey:key];
    
    XCTAssertNotEqualObjects(generatedUUID, MISUUIDDefaultIdentifier, @"Generated UUID should not be the default identifier");
    XCTAssertEqual(generatedUUID.length, 36, @"Generated UUID should be in RFC-4122 format and 36 characters long");
}
@end
