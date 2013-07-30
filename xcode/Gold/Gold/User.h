//
//  User.h
//  Gold
//
//  Created by Grant Wenzlau on 7/22/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong) NSString *signature;
@property (strong) NSString *email;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (void)createUserWithUsername:(NSString *)username
                         email:(NSString *)email
                      password:(NSString *)password
                         block:(void (^)(User *user))block;

@end