//
//  NSDictionary+NonNull.h
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NonNull)

- (id)nonNullValueForKeyPath:(NSString *)keypath;

@end
