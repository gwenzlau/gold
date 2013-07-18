//
//  APIClient.m
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "APIClient.h"

#define BASE_URL @"http://mysterious-hollows-5550.herokuapp.com/"

@implementation APIClient

+ (id)sharedClient {
    static APIClient *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:BASE_URL];
        __instance = [[APIClient alloc] initWithBaseURL:url];
    });
    return __instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"oaccessToken"];
//    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"orefreshToken"];
//    
//    [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
    
    return self;
}


@end
