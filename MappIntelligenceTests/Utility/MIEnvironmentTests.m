//
//  MIEnvironmentTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 26.9.24..
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

// TestDevice.h
#import <UIKit/UIKit.h>

@interface TestDevice : UIDevice
@property (nonatomic, strong) NSString *mockSystemVersion;
@end

//// TestDevice.m
//#import "TestDevice.h"

@implementation TestDevice

- (NSString *)systemVersion {
    return self.mockSystemVersion ?: [super systemVersion];
}

@end

#import <XCTest/XCTest.h>
#import "MIEnvironment.h"
#import <OCMock/OCMock.h>
#import <sys/utsname.h>

@interface MIEnvironmentTests : XCTestCase

@property (nonatomic, strong) id mockDeviceClass;
@property (nonatomic, strong) TestDevice *testDevice;

@end

@implementation MIEnvironmentTests

- (void)setUp {
    [super setUp];

    // Create a mock for UIDevice class
    self.mockDeviceClass = OCMClassMock([UIDevice class]);

    // Create a TestDevice instance to use in our tests
    self.testDevice = [[TestDevice alloc] init];
    self.testDevice.mockSystemVersion = @"15.0";

    // Stub currentDevice to return our test device
    OCMStub([self.mockDeviceClass currentDevice]).andReturn(self.testDevice);
}

- (void)tearDown {
    [self.mockDeviceClass stopMocking];
    self.mockDeviceClass = nil;
    self.testDevice = nil;
    [super tearDown];
}

// Test appVersion method
- (void)testAppVersion {
    // Mock the infoDictionary to return a specific version
    NSDictionary *mockInfoDictionary = @{@"CFBundleShortVersionString": @"1.2.3"};
    id mockBundle = OCMClassMock([NSBundle class]);
    OCMStub([mockBundle mainBundle]).andReturn(mockBundle);
    OCMStub([mockBundle infoDictionary]).andReturn(mockInfoDictionary);
    
    NSString *appVersion = [MIEnvironment appVersion];
    XCTAssertEqualObjects(appVersion, @"1.2.3", @"The app version should be 1.2.3");
}

// Test deviceModelString method
- (void)testDeviceModelString {
    id mockDevice = OCMClassMock([UIDevice class]);
    
#if TARGET_IPHONE_SIMULATOR
    NSString *deviceModel = [MIEnvironment deviceModelString];
    XCTAssertEqualObjects(deviceModel, @"iPhone", @"On the simulator, the device model should be iPhone");
#else
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *expectedModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *deviceModel = [MIEnvironment deviceModelString];
    XCTAssertEqualObjects(deviceModel, expectedModel, @"The device model string should match the actual system information");
#endif
}

// Test operatingSystemName method
- (void)testOperatingSystemName {
    id mockDevice = OCMClassMock([UIDevice class]);
    OCMStub([mockDevice currentDevice]).andReturn(mockDevice);
    OCMStub([mockDevice systemName]).andReturn(@"iOS");

    NSString *osName = [MIEnvironment operatingSystemName];
    XCTAssertEqualObjects(osName, @"iOS", @"The operating system name should be iOS");
}

// Test operatingSystemVersionString method
- (void)testOperatingSystemVersionString {
    // Call the method under test
    NSString *osVersion = [MIEnvironment operatingSystemVersionString];

    // Verify that the mocked systemVersion is returned
    XCTAssertEqualObjects(osVersion, @"15.0", @"The operating system version should be 15.0");

}

// Test buildVersion method
- (void)testBuildVersion {
    NSDictionary *mockInfoDictionary = @{@"CFBundleVersion": @"42"};
    id mockBundle = OCMClassMock([NSBundle class]);
    OCMStub([mockBundle mainBundle]).andReturn(mockBundle);
    OCMStub([mockBundle infoDictionary]).andReturn(mockInfoDictionary);
    
    NSString *buildVersion = [MIEnvironment buildVersion];
    XCTAssertEqualObjects(buildVersion, @"42", @"The build version should be 42");
}

// Test appUpdated method (when no previous version exists)
- (void)testAppUpdated_NoPreviousVersion {
    id mockUserDefaults = OCMClassMock([NSUserDefaults class]);
    OCMStub([mockUserDefaults standardUserDefaults]).andReturn(mockUserDefaults);
    OCMStub([mockUserDefaults stringForKey:@"kAppVersion"]).andReturn(nil);

    id mockEnvironment = OCMClassMock([MIEnvironment class]);
    OCMStub([mockEnvironment appVersion]).andReturn(@"1.2.3");
    
    BOOL isUpdated = [MIEnvironment appUpdated];
    XCTAssertFalse(isUpdated, @"If no previous version exists, appUpdated should return NO");
}

// Test appUpdated method (when app is updated)
- (void)testAppUpdated_AppUpdated {
    id mockUserDefaults = OCMClassMock([NSUserDefaults class]);
    OCMStub([mockUserDefaults standardUserDefaults]).andReturn(mockUserDefaults);
    OCMStub([mockUserDefaults stringForKey:@"kAppVersion"]).andReturn(@"1.0.0");

    id mockEnvironment = OCMClassMock([MIEnvironment class]);
    OCMStub([mockEnvironment appVersion]).andReturn(@"1.2.3");
    
    BOOL isUpdated = [MIEnvironment appUpdated];
    XCTAssertTrue(isUpdated, @"If the previous version is different, appUpdated should return YES");
}

// Test appUpdated method (when app is not updated)
- (void)testAppUpdated_NoUpdate {
    id mockUserDefaults = OCMClassMock([NSUserDefaults class]);
    OCMStub([mockUserDefaults standardUserDefaults]).andReturn(mockUserDefaults);
    OCMStub([mockUserDefaults stringForKey:@"kAppVersion"]).andReturn(@"1.2.3");

    id mockEnvironment = OCMClassMock([MIEnvironment class]);
    OCMStub([mockEnvironment appVersion]).andReturn(@"1.2.3");
    
    BOOL isUpdated = [MIEnvironment appUpdated];
    XCTAssertFalse(isUpdated, @"If the app version hasn't changed, appUpdated should return NO");
}

@end
