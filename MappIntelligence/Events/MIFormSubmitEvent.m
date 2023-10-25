//
//  MIFromSubmitEvent.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 1.2.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import "MIFormSubmitEvent.h"
#import <UIKit/UIKit.h>

@implementation MIFormSubmitEvent

@synthesize pageName = _pageName;

- (instancetype)init {
    self = [super init];
    _pageName = NSStringFromClass(self.topViewController.classForCoder);
    return self;
}

- (UIViewController*)topViewController {
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    UIViewController* topViewControler = [window rootViewController];
    if (!window || !topViewControler)
        return NULL;
    while( [topViewControler presentedViewController] ) {
        topViewControler = [topViewControler presentedViewController];
    }
    if ([topViewControler isKindOfClass:UINavigationController.class]) {
        return ((UINavigationController*)topViewControler).topViewController;
    }
    return topViewControler;
}

@end
