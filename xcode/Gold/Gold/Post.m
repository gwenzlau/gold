//
//  Post.m
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "Post.h"
#import "AFNetworking.h"
#import "BlocksKit.h"
#import "APIClient.h"
#import "NSDictionary+JSONValueParsing.h"
#import "Notifications.h"

@implementation Post

@synthesize content, thumbnailUrl, photoData, largeUrl;

+ (void) fetchNearbyPosts:(void (^)(NSArray *, NSError *))completionBlock {
    [[APIClient sharedClient] getPath:@"/posts.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode ==200) {
            NSArray *posts = [Post postsWithJSON:responseObject];
            completionBlock(posts, nil);
        } else {
            NSLog(@"received an HTTP %d: %@", operation.response.statusCode, responseObject);
            completionBlock(nil, nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    }];
}

+ (NSArray *) postsWithJSON:(NSArray *)postsJson {
    return [postsJson map:^id(id itemJson) {
        return [Post postFromJSON:itemJson];
        
    }];
}

+ (Post *)postFromJSON:(NSDictionary *)dictionary {
    Post *post = [[Post alloc] init];
    [post updateFromJSON:dictionary];
    
    return post;
}

- (void)updateFromJSON:(NSDictionary *)dictionary {
    self.content = [dictionary stringForKey:@"content"];
    
    NSDictionary *photoDictionary = [dictionary objectForKey:@"photo"];
    self.largeUrl = [photoDictionary stringForKey:@"url"];
    
   // NSString *photoKey = IsRetina() ? @"thumb_retina" : @"thumb";
    NSDictionary *thumbDictionary = [photoDictionary objectForKey:@"thumbnailUrl"];
    self.thumbnailUrl = [thumbDictionary stringForKey:@"url"];
}

- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {
    [self saveWithProgress:nil completion:completionBlock];
}

- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    if (!self.content) self.content = @"";
    
    NSDictionary *params = @{
                             @"post[content]" : self.content
                             };
    NSURLRequest *postRequest = [[APIClient sharedClient] multipartFormRequestWithMethod:@"POST"
                                                                                    path:@"/posts"
                                                                              parameters:params
                                                               constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      [formData appendPartWithFileData:self.photoData
                                                                  name:@"post[photo]"
                                                              fileName:@"photopost.png"
                                                              mimeType:@"image/png"];
                                  }];
//below, I changed the NSInteger to NSUInteger to fix the error- this differs from BL...
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"Created, %@", responseObject);
            NSDictionary *updatedLatte = [responseObject objectForKey:@"post"];
            [self updateFromJSON:updatedLatte];
            [self notifyCreated];
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    }];
    
    [[APIClient sharedClient] enqueueHTTPRequestOperation:operation];
};

- (void)notifyCreated {
    [[NSNotificationCenter defaultCenter] postNotificationName:PostCreatedNotification
                                                        object:self];
}

@end
