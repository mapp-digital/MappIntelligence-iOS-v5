//
//  MIExceptionTrackerTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 17.10.24..
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MIExceptionTracker.h"
#import "MIDefaultTracker.h"
#import "MappIntelligenceLogger.h"

@interface MIExceptionTrackerTests : XCTestCase

@property (nonatomic, strong) MIExceptionTracker *exceptionTracker;
@property (nonatomic, strong) id mockTracker;
@property (nonatomic, strong) id mockLogger;

@end

@implementation MIExceptionTrackerTests

- (void)setUp {
    [super setUp];
        
    self.mockTracker = OCMClassMock([MIDefaultTracker class]);
    self.mockLogger = OCMClassMock([MappIntelligenceLogger class]);
        
        // Ensure the shared instances are available
    [MappIntelligenceLogger shared];
    [MIDefaultTracker sharedInstance];

    self.exceptionTracker = [[MIExceptionTracker alloc] init];
}

- (void)tearDown {
    self.exceptionTracker = nil;
    [self.mockTracker stopMocking];
    [self.mockLogger stopMocking];
}

// Test initialization
- (void)testInitialization {
    XCTAssertNotNil(self.exceptionTracker);
    XCTAssertFalse(self.exceptionTracker.initialized);
}

// Test initializing exception tracking
- (void)testInitializeExceptionTracking {
    [self.exceptionTracker initializeExceptionTracking];
    XCTAssertTrue(self.exceptionTracker.initialized);
}

// Test checkIfInitialized returns NO if not initialized
- (void)testCheckIfNotInitialized {
    NSError *error = [self.exceptionTracker trackInfoWithName:@"TestException" andWithMessage:@"Test message"];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 900);
}

// Test tracking an uncaught exception
- (void)testTrackException_Uncaught {
    [self.exceptionTracker initializeExceptionTracking];
    [self.exceptionTracker setTypeOfExceptionsToTrack:uncaught];
    
    NSException *exception = [NSException exceptionWithName:@"TestException"
                                                     reason:@"Test reason"
                                                   userInfo:nil];
    
    OCMStub([self.mockTracker trackWithCustomEvent:[OCMArg any]]).andReturn(nil);
    
    NSError *error = [self.exceptionTracker trackException:exception];
    
    XCTAssertNil(error);
}

// Test tracking info with custom type
- (void)testTrackInfoWithName_CustomType {
    [self.exceptionTracker initializeExceptionTracking];
    self.exceptionTracker.typeOfExceptionsToTrack = custom_and_caught;
    
    NSError *error = [self.exceptionTracker trackInfoWithName:@"CustomInfo" andWithMessage:@"Custom message"];
    
    XCTAssertNil(error);
}

// Test tracking error
- (void)testTrackError {
    [self.exceptionTracker initializeExceptionTracking];
    [self.exceptionTracker setTypeOfExceptionsToTrack:caught];
    
    NSError *error = [NSError errorWithDomain:@"TestDomain" code:500 userInfo:@{NSLocalizedDescriptionKey: @"Test error description"}];
    
    OCMStub([self.mockTracker trackWithCustomEvent:[OCMArg any]]).andReturn(nil);
    
    NSError *trackedError = [self.exceptionTracker trackError:error];
    
    XCTAssertNil(trackedError);
}


// Test tracking with type
- (void)testTrackWithType {
    [self.exceptionTracker initializeExceptionTracking];
    [self.exceptionTracker setTypeOfExceptionsToTrack:uncaught];
    
    OCMStub([self.mockTracker trackWithCustomEvent:[OCMArg any]]).andReturn(nil);
    
    NSError *error = [self.exceptionTracker trackExceptionWithName:@"TestName" andReason:@"TestMessage" andUserInfo:@"" andCallStackReturnAddress:@"" andCallStackSymbols:@""];
    
    
    XCTAssertNil(error);
}

@end
