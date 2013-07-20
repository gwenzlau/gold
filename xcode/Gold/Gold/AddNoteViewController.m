//
//  AddNoteViewController.m
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AddNoteViewController.h"
#import "Post.h"
#import "ProgressView.h"

@interface AddNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (strong) CLLocationManager *locationManager;

@end

@implementation AddNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [self saveButton];
}

- (UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                         target:self
                                                         action:@selector(save:)];
}



//I'm trying to get a POST method that doenst require photoData- and perhaps could pass lat/lng.. so combining with zuzu, not exactly working yet..........

- (void)save:(id)sender

{
    
    Post *post = [[Post alloc] init];
    post.content = self.contentTextField.text;
    //post.location = self.
    
    [self.view endEditing:YES];
    
    ProgressView *progressView = [ProgressView presentInWindow:self.view.window];
    
    [post saveWithProgress:^(CGFloat progress) {
        [progressView setProgress:progress];
    } completion:^(BOOL success, NSError *error) {
        [progressView dismiss];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

//    {
//        
//        NSDictionary *params = @{
//                                 @"post[content]" : self.content,
//                                 @"post[lat]" : self.location,
//                                 // it was this... : @(location.coordinate.latitude),
//                                 @"post[lng]" : self.location
//                                 //: @(location.coordinate.longitude)
////                      [params setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"post[lat]"];
////                      [params setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"post[lng]"];
//                                 };
//        [[APIClient sharedClient] postPath:@"/posts" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            Post *post = [[Post alloc] initWithDictionary:responseObject];
//            if (block) {
//                block(post, nil);
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            if (block) {
//                block(nil, error);
//                NSLog(@"ERROR: %@", error);
//            }
//        }];
//    }

//    [post saveWithProgress:^(CGFloat progress) {
//        [progressView setProgress:progress];
//    } completion:^(BOOL success, NSError *error) {
//        [progressView dismiss];
//        if (success) {
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            NSLog(@"ERROR: %@", error);
//        }
//    }];
//}

@end
