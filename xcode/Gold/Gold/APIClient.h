//
//  APIClient.h
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//
#import "AFNetworking.h"
#import "AFHTTPClient.h"

////API call completion block with result as json
//typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface APIClient : AFHTTPClient

+ (id)sharedClient;

@property (strong, nonatomic) NSDictionary* user;

//check for user authorization
-(BOOL)isAuthorized;

////send API command to server
//-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

@end
