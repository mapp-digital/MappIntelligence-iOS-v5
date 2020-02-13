//
//  DefaultTracker.h
//  MappIntelligenceSDK
//
//  Created by Vladan Randjelovic on 10/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#ifndef DefaultTracker_h
#define DefaultTracker_h
#import <UIKit/UIKit.h>

#endif /* DefaultTracker_h */

@interface DefaultTracker:NSObject
-(NSString*)generateEverId;
-(void)track:(UIViewController*)controller;
+(NSUserDefaults*)sharedDefaults;
@end
