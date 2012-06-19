//
//  EICollections.m
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 6. 19..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "EICollections.h"

@implementation EICollections

@end

id dictget(NSDictionary* dictionary, NSString* keyPath) {
    NSArray* keys = [keyPath componentsSeparatedByString:@"."];
    NSDictionary* path = dictionary;
    for (NSString* key in keys) {
        path = [path objectForKey:key];
    }
    return path;
}