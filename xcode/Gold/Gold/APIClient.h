//
//  APIClient.h
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//
#import "AFNetworking.h"
#import "AFHTTPClient.h"

@interface APIClient : AFHTTPClient

+ (id)sharedClient;

@end
