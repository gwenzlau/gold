//
//  NSDictionary+NonNull.m
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "NSDictionary+NonNull.h"

@implementation NSDictionary (NonNull)

- (id)nonNullValueForKeyPath:(NSString *)keypath {
    id value = [self valueForKeyPath:keypath];
    if (value && ![value isEqual:[NSNull null]]) {
        return value;
    }

    return nil;
}

@end
