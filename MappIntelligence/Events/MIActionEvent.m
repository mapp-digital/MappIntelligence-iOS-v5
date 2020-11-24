//
//  MIActionEvent.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIActionEvent.h"

@implementation MIActionEvent

@synthesize pageName = _pageName;

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    _name = name;
    return self;
}

- (NSString *)pageName {
    return @"0";
}

-(NSMutableArray<NSURLQueryItem*>*)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_name) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"ct" value:_name]];
    }
    items = [NSMutableArray arrayWithArray:[items arrayByAddingObjectsFromArray:[_actionProperties asQueryItems]]];
    return items;
}

@end
