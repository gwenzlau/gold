//
//  APIClient.m
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "APIClient.h"
#define BASE_URL @"http://localhost:3000/"

//#define BASE_URL @"http://mysterious-hollows-5550.herokuapp.com/"

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

-(BOOL)isAuthorized {
    return [[_user objectForKey:@"IdUser"] intValue]>0;
}

//-(void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock {
//    NSData* uploadFile = nil;
//    if([params objectForKey:@"photoData"]) {
//        uploadFile = (NSData*)[params objectForKey:@"photoData"];
//        [params removeObjectForKey:@"photoData"];
//    }
//    NSMutableURLRequest *apiRequest =
//    [self multipartFormRequestWithMethod:@"POST"
//                                    path:@"/posts"
//                              parameters:params
//               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                   if (uploadFile) {
//                       [formData appendPartWithFileData:uploadFile
//                                                   name:@"photoData"
//                                               fileName:@"photo.jpg"
//                                               mimeType:@"image/jpeg"];
//                   }
//               }];
//    
//    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest:apiRequest];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //success
//        completionBlock(responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
//    }];
//    
//    [operation start];
//}

@end
