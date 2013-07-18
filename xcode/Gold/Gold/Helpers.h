//
//  Helpers.h
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline BOOL IsRetina() {
    UIScreen* s = [UIScreen mainScreen];
    if ([s respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        [s respondsToSelector:@selector(scale)])
    {
        CGFloat scale = [s scale];
        return scale == 2.0;
    }
    
    return NO;
}