//
//  Tracker.h
//  MappIntelligenceSDK
//
//  Created by Vladan Randjelovic on 11/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !os(watchOS)
#import <AVFoundation/AVFoundation.h>
#endif

@protocol Tracjer <class>

@property NSString *everID {get, set}
@property


@end
