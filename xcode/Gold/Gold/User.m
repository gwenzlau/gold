//
//  User.m
//  Gold
//
//  Created by Grant Wenzlau on 7/30/13.
//  Copyright (c) 2013 marko. All rights reserved.

#import "User.h"
#import "APIClient.h"
#import "NSDictionary+NonNull.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.signature = [dictionary nonNullValueForKeyPath:@"signature"];
    self.email = [dictionary nonNullValueForKeyPath:@"email"];
    
    return self;
}

+ (void)createUserWithUsername:(NSString *)signature
                         email:(NSString *)email
                      password:(NSString *)password
                         block:(void (^)(User *user))block
{
    NSDictionary *parameters = @{ @"user": @{
                                  @"signature": signature,
                                 @"email": email,
                                 @"password": password
                                  }
                                 };
    
    [[APIClient sharedClient] postPath:@"/users" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *user = [[User alloc] initWithDictionary:responseObject];
        
        if (block) {
            block(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (block) {
            block(nil);
        }
    }];
}

+ (void)loginUser:(NSString *)signature
                         email:(NSString *)email
                      password:(NSString *)password
                         block:(void (^)(User *user))block
{
    NSDictionary *parameters = @{ @"user": @{
                                    //      @"signature": signature,
                                          @"email": email,
                                          @"password": password
                                          }
                                  };
    
    [[APIClient sharedClient] postPath:@"/users/sign_in" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *user = [[User alloc] initWithDictionary:responseObject];
        
        if (block) {
            block(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (block) {
            block(nil);
        }
    }];
}

@end
