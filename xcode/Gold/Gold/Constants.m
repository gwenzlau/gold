//
//  Constants.m
//  Gold
//
//  Created by Grant Wenzlau on 7/31/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+(NSString *)pictureBucket {
        return [[NSString stringWithFormat:@"%@-%@", PICTURE_BUCKET, ACCESS_KEY_ID] lowercaseString];
    }

@end
