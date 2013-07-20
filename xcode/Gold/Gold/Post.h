//
//  Post.h
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Post : NSObject

//+ (void)fetchNearbyPosts: (void (^)(NSArray *posts, NSError *error))completionBlock;
+ (void)fetchNearbyPosts:(CLLocation *)location
          withBlock:(void (^)(NSArray *posts, NSError *error))completionBlock;
//+ (void)postsNearby:(CLLocation *)location
//          withBlock:(void (^)(NSArray *posts, NSError *error))completionBlock;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *largeUrl;
@property (nonatomic, strong) NSData *photoData;
@property (strong) CLLocation *location;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock;

//- (void)saveWithProgress: (CLLocation *)location
//               withBlock:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock;
- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock;


+ (void)savePostAtLocation:(CLLocation *)location
               withContent:(NSString *)content
                     block:(void (^)(Post *post, NSError *error))block;

@end
