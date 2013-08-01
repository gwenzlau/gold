//
//  Constants.h
//  Gold
//
//  Created by Grant Wenzlau on 7/31/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>


// Constants used to represent your AWS Credentials.
#define ACCESS_KEY_ID          @"CHANGE ME"
#define SECRET_KEY             @"CHANGE ME"


// Constants for the Bucket and Object name.
#define PICTURE_BUCKET         @"Marko"
#define PICTURE_NAME           @"NameOfThePicture"


#define CREDENTIALS_ERROR_TITLE    @"Missing Credentials"
#define CREDENTIALS_ERROR_MESSAGE  @"AWS Credentials not configured correctly.  Please review the README file."


@interface Constants : NSObject {
    
}

+(NSString *)pictureBucket;

@end
