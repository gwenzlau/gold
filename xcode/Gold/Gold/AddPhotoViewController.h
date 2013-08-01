//
//  AddPhotoViewController.h
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>

typedef enum {
 //   GrandCentralDispatch,
  //  Delegate,
    BackgroundThread
} UploadType;

@interface AddPhotoViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AmazonServiceRequestDelegate> {
    UploadType _uploadType;
}

@property (nonatomic, retain) AmazonS3Client *s3;

@end
