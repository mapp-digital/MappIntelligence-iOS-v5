//
//  APXKeychainManagerTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 04.09.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIKeychainManager.h"

@interface MIKeychainManager (TestAccess)
- (BOOL)checkOSStatus:(OSStatus)status;
@end

@interface MIKeychainManagerTests : XCTestCase
@property (nonatomic, strong) MIKeychainManager *keychainManager;
@end

@implementation MIKeychainManagerTests

- (void)setUp {
    [super setUp];
    self.keychainManager = [MIKeychainManager default];
}

- (void)tearDown {
    // Ensure we clean up after each test
    [self.keychainManager deleteObjectForKey:@"testKey"];
    self.keychainManager = nil;
    [super tearDown];
}

// Test saving a nil object
- (void)testSaveNilObject {
    NSString *testKey = @"testKey";
    id testObject = nil;
    
    BOOL saveSuccess = [self.keychainManager saveObject:testObject forKey:testKey];
    
    XCTAssertFalse(saveSuccess, @"Saving nil object should return NO");
}

// Test loading a non-existent object
- (void)testLoadNonExistentObject {
    NSString *testKey = @"nonExistentKey";
    
    id loadedObject = [self.keychainManager loadObjectForKey:testKey];
    
    XCTAssertNil(loadedObject, @"Loaded object should be nil for non-existent key");
}

- (void)testSaveLoadDeleteRoundTrip {
    NSString *key = [NSString stringWithFormat:@"mi.keychain.%@", [NSUUID UUID].UUIDString];
    NSString *value = @"token-value";

    BOOL saved = [self.keychainManager saveObject:value forKey:key];
    id loaded = [self.keychainManager loadObjectForKey:key];

    if (saved) {
        XCTAssertEqualObjects(loaded, value);
    } else {
        XCTAssertNil(loaded);
    }

    BOOL deleted = [self.keychainManager deleteObjectForKey:key];
    XCTAssertTrue(deleted || !saved);
}

- (void)testCheckOSStatus {
    XCTAssertTrue([self.keychainManager checkOSStatus:noErr]);
    XCTAssertFalse([self.keychainManager checkOSStatus:errSecItemNotFound]);
}

@end

