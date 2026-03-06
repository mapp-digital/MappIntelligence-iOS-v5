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

static UIWindow *MIFormSubmitEventTestWindow = nil;

+ (void)setTestWindow:(UIWindow *)window {
    MIFormSubmitEventTestWindow = window;
}

- (instancetype)init {
    self = [super init];
    _pageName = NSStringFromClass(self.topViewController.classForCoder);
    return self;
}

- (UIWindow *)activeWindow {
    if (MIFormSubmitEventTestWindow) {
        return MIFormSubmitEventTestWindow;
    }
    UIApplication *application = [UIApplication sharedApplication];
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in application.connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            for (UIWindow *sceneWindow in windowScene.windows) {
                if (sceneWindow.isKeyWindow) {
                    return sceneWindow;
                }
            }
            if (windowScene.windows.count > 0) {
                return windowScene.windows.firstObject;
            }
        }
    }
    UIWindow *keyWindow = application.keyWindow;
    if (keyWindow) {
        return keyWindow;
    }
    return application.windows.firstObject;
}

- (UIViewController*)topViewController {
    UIWindow* window = [self activeWindow];
    UIViewController* topViewControler = [window rootViewController];
    if (!window || !topViewControler) {
        return NULL;
    }
    while( [topViewControler presentedViewController] ) {
        topViewControler = [topViewControler presentedViewController];
    }
    if ([topViewControler isKindOfClass:UINavigationController.class]) {
        return ((UINavigationController*)topViewControler).topViewController;
    }
    return topViewControler;
}

@end
