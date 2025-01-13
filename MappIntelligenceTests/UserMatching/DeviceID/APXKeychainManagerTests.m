//
//  APXKeychainManagerTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 04.09.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIKeychainManager.h"

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

@end

