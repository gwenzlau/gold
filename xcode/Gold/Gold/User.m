//
//  User.m
//  Gold
//
//  Created by Grant Wenzlau on 7/22/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "User.h"
#import "APIClient.h"
#import "NSDictionary+NonNull.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.email = [dictionary nonNullValueForKeyPath:@"email"];
    self.signature = [dictionary nonNullValueForKeyPath:@"signature"];
    
    return self;
}

+ (void)createUserWithUsername:(NSString *)signature
email:(NSString *)email
password:(NSString *)password
block:(void (^)(User *user))block
{
    NSDictionary *parameters = @{
                                 @"email": email,
                                 @"password": password,
                                 @"signature": signature
                                 };
    
    [[APIClient sharedClient] postPath:@"/users/index" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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