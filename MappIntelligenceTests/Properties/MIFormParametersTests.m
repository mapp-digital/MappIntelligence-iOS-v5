//
//  MIFormParametersTests.m
//  MappIntelligenceTests
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "MIFormParameters.h"
#import "MIFormField.h"

@interface MIFormParameters (TestAccess)
- (NSArray<UITextField *> *)getTextFields:(UIView *)mainView;
- (NSArray<UITextView *> *)getTextViews:(UIView *)mainView;
- (NSArray<UISwitch *> *)getSwithces:(UIView *)mainView;
- (NSArray<UIPickerView *> *)getPickerViews:(UIView *)mainView;
- (NSArray<UISegmentedControl *> *)getSegmetedControls:(UIView *)mainView;
- (void)setTrackableFields;
- (NSString *)getNameForControl:(UIView *)control;
- (void)createFromFields;
- (NSString *)extractLabelFromPickerView:(UIView *)godView;
- (NSString *)extractValueForAllComponentOfPickerView:(UIPickerView *)pickerView;
- (NSURLQueryItem *)asQueryItemsForPatyAnylisis;
- (void)prepareFields;
- (void)populatePathFields;
- (NSString *)getFormForQuery;
- (UIViewController *)topViewController;
@end

@interface MITestPickerView : UIPickerView
@property (nonatomic, assign) BOOL returnNilView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *components;
@property (nonatomic, strong) NSArray<NSNumber *> *selectedRows;
@end

@implementation MITestPickerView

- (NSInteger)numberOfComponents {
    return self.components.count;
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    if (component < self.selectedRows.count) {
        return self.selectedRows[component].integerValue;
    }
    return 0;
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.returnNilView) {
        return nil;
    }
    if (component < self.components.count && row < self.components[component].count) {
        UILabel *label = [[UILabel alloc] init];
        label.text = self.components[component][row];
        return label;
    }
    return nil;
}


@end

@interface MIFormParametersTestable : MIFormParameters
@property (nonatomic, strong) UIViewController *testTopViewController;
@end

@implementation MIFormParametersTestable

- (UIViewController *)topViewController {
    return self.testTopViewController;
}


@end

static IMP MIFormParametersKeyWindowIMP = NULL;
static IMP MIFormParametersSharedApplicationIMP = NULL;
static id MIFormParametersTestApplication = nil;

@interface MITestApplication : NSObject
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) UIApplicationState applicationState;
@property (nonatomic, weak) id<UIApplicationDelegate> delegate;
@end

@implementation MITestApplication

- (instancetype)init {
    self = [super init];
    if (self) {
        _applicationState = UIApplicationStateActive;
    }
    return self;
}

- (UIWindow *)keyWindow {
    return self.window;
}

@end

@interface MIFormParametersTests : XCTestCase
@property (nonatomic, strong) MIFormParameters *formParameters;
@property (nonatomic, strong) UIWindow *window;
- (void)swizzleKeyWindow:(UIWindow *)window;
- (void)restoreKeyWindowSwizzle;
- (void)swizzleSharedApplicationWithWindow:(UIWindow *)window;
- (void)restoreSharedApplicationSwizzle;
@end

@implementation MIFormParametersTests

- (void)setUp {
    [super setUp];
    self.formParameters = [[MIFormParameters alloc] init];
}

- (void)tearDown {
    self.formParameters = nil;
    [self restoreSharedApplicationSwizzle];
    [self restoreKeyWindowSwizzle];
    [self resetKeyWindow];
    [super tearDown];
}

- (void)testInitWithDictionaryParsesFields {
    NSDictionary *fieldDict = @{ @"mi_form_field_name": @"name", @"mi_field_content": @"value", @"mi_anonymus": @YES, @"mi_last_focus": @NO };
    NSDictionary *dict = @{
        @"form_name": @"Form",
        @"field_ids": @[ @1 ],
        @"rename_ids": @{ @1: @"renamed" },
        @"change_fields_value": @{ @1: @"changed" },
        @"anonymous_specific_fields": @[ @1 ],
        @"full_content_specific_fields": @[ @1 ],
        @"confirm_button": @NO,
        @"anonymous": @YES,
        @"path_analysis": @[ @1 ],
        @"mi_form_fields": @[ fieldDict ]
    };

    MIFormParameters *params = [[MIFormParameters alloc] initWithDictionary:dict];
    XCTAssertEqualObjects(params.formName, @"Form");
    XCTAssertEqualObjects(params.fieldIds, (@[@1]));
    XCTAssertEqualObjects(params.renameFields[@1], @"renamed");
    XCTAssertEqualObjects(params.changeFieldsValue[@1], @"changed");
    XCTAssertEqualObjects(params.anonymousSpecificFields, (@[@1]));
    XCTAssertEqualObjects(params.fullContentSpecificFields, (@[@1]));
    XCTAssertTrue(params.confirmButton);
    XCTAssertEqualObjects(params.anonymous, @YES);
    XCTAssertEqualObjects(params.pathAnalysis, (@[@1]));
    NSArray *fields = [params valueForKey:@"fields"];
    XCTAssertEqual(fields.count, 1);
}

- (void)testSetTrackableFieldsFiltersByIds {
    UITextField *fieldOne = [[UITextField alloc] init];
    fieldOne.tag = 1;
    UITextField *fieldTwo = [[UITextField alloc] init];
    fieldTwo.tag = 2;

    [self.formParameters setValue:[@[fieldOne, fieldTwo] mutableCopy] forKey:@"textFields"];
    self.formParameters.fieldIds = @[ @1 ];

    [self runOnBackgroundAndWait:^{
        [self.formParameters setTrackableFields];
    }];

    NSArray *filtered = [self.formParameters valueForKey:@"textFields"];
    XCTAssertEqual(filtered.count, 1);
    XCTAssertEqual(((UITextField *)filtered.firstObject).tag, 1);
}

- (void)testExtractLabelFromPickerViewRecursesAndReturnsEmpty {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"label";
    UIView *container = [[UIView alloc] init];
    [container addSubview:label];

    XCTAssertEqualObjects([self.formParameters extractLabelFromPickerView:label], @"label");
    XCTAssertEqualObjects([self.formParameters extractLabelFromPickerView:container], @"label");

    UIView *emptyContainer = [[UIView alloc] init];
    XCTAssertEqualObjects([self.formParameters extractLabelFromPickerView:emptyContainer], @"empty");
}

- (void)testExtractValueForAllComponentOfPickerViewUsesFallback {
    MITestPickerView *picker = [[MITestPickerView alloc] init];
    picker.components = @[ @[ @"A" ], @[ @"B" ] ];
    picker.selectedRows = @[ @0, @0 ];
    picker.returnNilView = YES;

    UIView *componentsContainer = [[UIView alloc] init];
    UIView *componentView0 = [[UIView alloc] init];
    UILabel *label0 = [[UILabel alloc] init];
    label0.text = @"A";
    [componentView0 addSubview:label0];

    UIView *componentView1 = [[UIView alloc] init];
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"B";
    [componentView1 addSubview:label1];

    [componentsContainer addSubview:componentView0];
    [componentsContainer addSubview:componentView1];
    [picker addSubview:componentsContainer];

    NSString *value = [self.formParameters extractValueForAllComponentOfPickerView:picker];
    XCTAssertEqualObjects(value, @"A/B");
}

- (void)testGetNameForControlIncludesLabelAndClass {
    UITextField *field = [[UITextField alloc] init];
    field.accessibilityLabel = @"label";
    NSString *name = [self.formParameters getNameForControl:field];
    XCTAssertTrue([name containsString:@"label."]);

    UITextField *noLabelField = [[UITextField alloc] init];
    NSString *noLabelName = [self.formParameters getNameForControl:noLabelField];
    XCTAssertTrue([noLabelName hasPrefix:@"n/a."]);
}

- (void)testCreateFromFieldsBuildsFieldsAndAppliesOverrides {
    UIViewController *root = [[UIViewController alloc] init];
    UIView *rootView = root.view;

    MIFormParametersTestable *testable = [[MIFormParametersTestable alloc] init];
    testable.testTopViewController = root;

    UITextField *textField = [[UITextField alloc] init];
    textField.tag = 1;
    textField.text = @"text";
    textField.accessibilityLabel = @"field";
    [rootView addSubview:textField];

    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[ @"A", @"B" ]];
    segmented.tag = 2;
    segmented.selectedSegmentIndex = 1;
    segmented.accessibilityLabel = @"seg";
    [rootView addSubview:segmented];

    UISwitch *switchControl = [[UISwitch alloc] init];
    switchControl.tag = 3;
    switchControl.on = YES;
    switchControl.accessibilityLabel = @"switch";
    [rootView addSubview:switchControl];

    [self setKeyWindowWithRoot:root];

    testable.anonymous = @NO;
    testable.fieldIds = @[ @1, @2, @3 ];
    testable.renameFields = [@{ @1: @"renamed" } mutableCopy];
    testable.changeFieldsValue = [@{ @1: @"changed" } mutableCopy];
    testable.anonymousSpecificFields = @[ @2 ];
    testable.fullContentSpecificFields = @[ @3 ];

    [self runOnBackgroundAndWait:^{
        [testable createFromFields];
    }];

    NSArray *fields = [testable valueForKey:@"fields"];
    XCTAssertEqual(fields.count, 3);

    MIFormField *first = fields[0];
    XCTAssertTrue([first.formFieldName hasPrefix:@"renamed."]);
    XCTAssertEqualObjects(first.formFieldContent, @"changed");

    MIFormField *segField = fields[1];
    XCTAssertTrue(segField.anonymus);

    MIFormField *switchField = fields[2];
    XCTAssertFalse(switchField.anonymus);
}

- (void)testAsQueryItemsForPathAnalysisOrdersFields {
    MIFormField *emptyField = [[MIFormField alloc] initWithName:@"e" andContent:nil andID:1 andWithAnonymus:YES andFocus:NO];
    MIFormField *filledField = [[MIFormField alloc] initWithName:@"f" andContent:@"v" andID:2 andWithAnonymus:YES andFocus:NO];
    MIFormField *pathField = [[MIFormField alloc] initWithName:@"p" andContent:@"v" andID:3 andWithAnonymus:YES andFocus:NO];

    [self.formParameters setValue:[@[ emptyField, filledField, pathField ] mutableCopy] forKey:@"fields"];
    self.formParameters.pathAnalysis = @[ @3 ];

    NSURLQueryItem *item = [self.formParameters asQueryItemsForPatyAnylisis];
    XCTAssertEqualObjects(item.name, @"ft");
    XCTAssertTrue([item.value containsString:[emptyField getFormFieldForQuery]]);
    XCTAssertTrue([item.value containsString:[filledField getFormFieldForQuery]]);
    XCTAssertTrue([item.value containsString:[pathField getFormFieldForQuery]]);
}

- (void)testAsQueryItemsBuildsFormAndPathItems {
    [self setKeyWindowWithRoot:[[UIViewController alloc] init]];
    [self runOnBackgroundAndWait:^{
        NSArray *items = [self.formParameters asQueryItems];
        XCTAssertEqual(items.count, 2);
        NSURLQueryItem *fnItem = items[0];
        XCTAssertEqualObjects(fnItem.name, @"fn");
    }];
}

- (void)testGetFormForQueryUsesConfirmButtonV2 {
    self.formParameters.formName = @"Form";
    self.formParameters.confirmButton = YES;
    XCTAssertTrue(self.formParameters.confirmButton);
    XCTAssertTrue([[self.formParameters getFormForQuery] hasPrefix:@"Form|"]);
}

- (void)testTopViewControllerHandlesNavigationAndPresentationV2 {
    UIViewController *root = [[UIViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];

    UIViewController *presented = [[UIViewController alloc] init];
    [nav presentViewController:presented animated:NO completion:nil];

    [self setKeyWindowWithRoot:nav];
    [self swizzleSharedApplicationWithWindow:self.window];
    [self swizzleKeyWindow:self.window];

    [self runOnBackgroundAndWait:^{
        UIViewController *top = [self.formParameters topViewController];
        XCTAssertNotNil(top);
    }];

    [self restoreSharedApplicationSwizzle];
    [self restoreKeyWindowSwizzle];
}

- (void)testGetViewTraversalCollectsControls {
    UIView *root = [[UIView alloc] init];
    UITextField *field = [[UITextField alloc] init];
    UITextView *view = [[UITextView alloc] init];
    UISwitch *sw = [[UISwitch alloc] init];
    UIPickerView *picker = [[UIPickerView alloc] init];
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[ @"A" ]];

    UIView *container = [[UIView alloc] init];
    [container addSubview:field];
    [container addSubview:view];
    [container addSubview:sw];
    [container addSubview:picker];
    [container addSubview:segmented];
    [root addSubview:container];

    [self.formParameters getTextFields:root];
    [self.formParameters getTextViews:root];
    [self.formParameters getSwithces:root];
    [self.formParameters getPickerViews:root];
    [self.formParameters getSegmetedControls:root];

    XCTAssertEqual(((NSArray *)[self.formParameters valueForKey:@"textFields"]).count, 1);
    XCTAssertEqual(((NSArray *)[self.formParameters valueForKey:@"textViews"]).count, 1);
    XCTAssertEqual(((NSArray *)[self.formParameters valueForKey:@"switches"]).count, 1);
    XCTAssertEqual(((NSArray *)[self.formParameters valueForKey:@"pickers"]).count, 1);
    XCTAssertEqual(((NSArray *)[self.formParameters valueForKey:@"segmentedControls"]).count, 1);
}

#pragma mark - Helpers

- (void)runOnBackgroundAndWait:(dispatch_block_t)block {
    XCTestExpectation *expectation = [self expectationWithDescription:@"background"];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        block();
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)setKeyWindowWithRoot:(UIViewController *)root {
    if ([NSThread isMainThread]) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = root;
        [self.window makeKeyAndVisible];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.window.rootViewController = root;
            [self.window makeKeyAndVisible];
        });
    }
}

- (void)resetKeyWindow {
    if (!self.window) {
        return;
    }
    if ([NSThread isMainThread]) {
        self.window.rootViewController = nil;
        self.window.hidden = YES;
        self.window = nil;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.window.rootViewController = nil;
            self.window.hidden = YES;
            self.window = nil;
        });
    }
}

- (void)swizzleKeyWindow:(UIWindow *)window {
    if (MIFormParametersKeyWindowIMP != NULL) {
        return;
    }
    Method method = class_getInstanceMethod([UIApplication class], @selector(keyWindow));
    IMP newIMP = imp_implementationWithBlock(^UIWindow *(__unused id _self) {
        return window;
    });
    if (!method) {
        class_addMethod([UIApplication class], @selector(keyWindow), newIMP, "@@:");
        return;
    }
    MIFormParametersKeyWindowIMP = method_getImplementation(method);
    method_setImplementation(method, newIMP);
}

- (void)restoreKeyWindowSwizzle {
    if (MIFormParametersKeyWindowIMP == NULL) {
        return;
    }
    Method method = class_getInstanceMethod([UIApplication class], @selector(keyWindow));
    if (method) {
        method_setImplementation(method, MIFormParametersKeyWindowIMP);
    }
    MIFormParametersKeyWindowIMP = NULL;
}

- (void)swizzleSharedApplicationWithWindow:(UIWindow *)window {
    if (MIFormParametersSharedApplicationIMP != NULL) {
        return;
    }
    Class metaClass = object_getClass([UIApplication class]);
    Method method = class_getClassMethod([UIApplication class], @selector(sharedApplication));
    IMP newIMP = imp_implementationWithBlock(^id(__unused id _self) {
        return MIFormParametersTestApplication;
    });
    if (!method) {
        class_addMethod(metaClass, @selector(sharedApplication), newIMP, "@@:");
        MIFormParametersTestApplication = nil;
        MIFormParametersSharedApplicationIMP = NULL;
        return;
    }
    MIFormParametersSharedApplicationIMP = method_getImplementation(method);
    MITestApplication *testApp = [[MITestApplication alloc] init];
    testApp.window = window;
    MIFormParametersTestApplication = testApp;
    method_setImplementation(method, newIMP);
}

- (void)restoreSharedApplicationSwizzle {
    if (MIFormParametersSharedApplicationIMP == NULL) {
        return;
    }
    Class metaClass = object_getClass([UIApplication class]);
    Method method = class_getClassMethod([UIApplication class], @selector(sharedApplication));
    if (method) {
        method_setImplementation(method, MIFormParametersSharedApplicationIMP);
    } else {
        class_addMethod(metaClass, @selector(sharedApplication), MIFormParametersSharedApplicationIMP, "@@:");
    }
    MIFormParametersSharedApplicationIMP = NULL;
    MIFormParametersTestApplication = nil;
}


- (void)testConfirmButtonDefaultsTrue {
    MIFormParameters *params = [[MIFormParameters alloc] init];
    XCTAssertTrue(params.confirmButton);
}

@end
