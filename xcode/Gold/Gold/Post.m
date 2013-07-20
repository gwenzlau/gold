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
#import "ISO8601DateFormatter.h"
#import "Notifications.h"
#import "NSDictionary+NonNull.h"

static NSDate * NSDateFromISO8601String(NSString *string) {
    static ISO8601DateFormatter *_iso8601DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _iso8601DateFormatter = [[ISO8601DateFormatter alloc] init];
    });
    
    if (!string) {
        return nil;
    }
    
    return [_iso8601DateFormatter dateFromString:string];
}

static NSString * NSStringFromCoordinate(CLLocationCoordinate2D coordinate) {
    return [ NSString stringWithFormat:@"(%f, %f)", coordinate.latitude, coordinate.longitude];
}

static NSString * NSStringFromDate(NSDate *date) {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDoesRelativeDateFormatting:YES];
    });
    
    return [_dateFormatter stringFromDate:date];
}

@implementation Post

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.content = [dictionary valueForKey:@"content"];
    self.location = [[CLLocation alloc] initWithLatitude:[[dictionary nonNullValueForKeyPath:@"lat"] doubleValue] longitude:[[dictionary nonNullValueForKeyPath:@"lng"] doubleValue]];
    
    return self;
}

+ (void)fetchNearbyPosts:(CLLocation *)location
          withBlock:(void (^)(NSArray *posts, NSError *error))completionBlock
{
    NSDictionary *parameters = @{
                                 @"lat": @(location.coordinate.latitude),
                                 @"lng": @(location.coordinate.longitude)
                                 };
    
    [[APIClient sharedClient] getPath:@"/posts" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode ==200) {
        NSArray *posts = [Post postsWithJSON:responseObject];
        completionBlock(posts, nil);
        } else {
            NSLog(@"Recieved an HTTP %d: %@", operation.response.statusCode, responseObject);
            completionBlock(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
        NSLog(@"Error: %@", error);
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
    
    NSDictionary *locationDictionary = [dictionary objectForKey:@"location"];
    self.location = [[CLLocation alloc] initWithLatitude:[[locationDictionary valueForKey:@"lat"] doubleValue] longitude:[[locationDictionary valueForKey:@"lng"] doubleValue]];
}

- (void)saveWithCompletionAtLocation:(CLLocation *)location withBlock:(void (^)(BOOL, NSError *))completionBlock {
//- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {
   // [self saveWithProgress:nil completion:completionBlock];
    [self saveWithProgressAtLocation:location withBlock:nil completion:completionBlock];
}

- (void)saveWithProgressAtLocation:(CLLocation *)location
                         withBlock:(void (^)(CGFloat))progressBlock completion:(void (^)(BOOL, NSError *))completionBlock {
//- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    if (!self.content) self.content = @"";
    
//    NSDictionary *params = @{
//                             @"post[content]" : self.content,
//                             @"post[lat]": @(location.coordinate.latitude),
//                             @"post[lng]": @(location.coordinate.longitude)
//                             
//                             };
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"post[lat]"];
    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"post[lng]"];
    [mutableParameters setObject:[NSString stringWithFormat:self.content] forKey:@"post[content]"];
    
    NSURLRequest *postRequest = [[APIClient sharedClient] multipartFormRequestWithMethod:@"POST"
                                                                                    path:@"/posts"
                                                                              parameters:mutableParameters
                                                               constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      [formData appendPartWithFileData:self.photoData
                                                                  name:@"post[photo]"
                                                              fileName:@""
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
            NSDictionary *updatedPost = [responseObject objectForKey:@"post"];
            [self updateFromJSON:updatedPost];
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

- (void)savePostAtLocation:(CLLocation *)location
    withBlock:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
   // if (!self.content) self.content = @"";
    
    NSDictionary *params = @{
                             @"post[content]" : self.content,
                             @"post[lat]" : @(location.coordinate.latitude),
                             @"post[lng]" : @(location.coordinate.longitude)
                                  };
    
    [[APIClient sharedClient] postPath:@"/posts" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Post *post = [[Post alloc] initWithDictionary:responseObject];
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"Created, %@", responseObject);
            NSDictionary *updatedPost = [responseObject objectForKey:@"post"];
            [self updateFromJSON:updatedPost];
            [self notifyCreated];
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    }];
    
   // [[APIClient sharedClient] enqueueHTTPRequestOperation:operation];
}



- (void)notifyCreated {
    [[NSNotificationCenter defaultCenter] postNotificationName:PostCreatedNotification
                                                        object:self];
}

@end
