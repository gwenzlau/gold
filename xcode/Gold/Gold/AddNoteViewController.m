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

@interface AddNoteViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UITextView *textCountTextView;


@property (strong) CLLocationManager *locationManager;

@end

@implementation AddNoteViewController
@synthesize textCountTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [self saveButton];
}

- (UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                         target:self
                                                         action:@selector(save:)];
}



-(CLLocation *) getLocation{
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
// locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    [locationManager startUpdatingLocation];
    CLLocation * location = [locationManager location];
    return location;
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
    [self getLocation];
}

- (void)save:(id)sender

{
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
//  locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    [locationManager startUpdatingLocation];
    
    [self getLocation];
   // NSArray *locations;
    //CLLocation *location = [locations objectAtIndex:0];
    CLLocation * location = [locationManager location];


    Post *post = [[Post alloc] init];
    post.content = self.contentTextField.text;
    
//    UITextField *contentTextField = (UITextField *)sender;
//    int maxChars = 140;
//    int charsLeft = maxChars - [contentTextField.text length];
//    
//    textCountTextView.text = [NSString stringWithFormat:@"%d characters remaining.",charsLeft];
    
    [self.view endEditing:YES];
    
    ProgressView *progressView = [ProgressView presentInWindow:self.view.window];
    if (location) {
        
        [Post createNoteAtLocation:location withContent:self.contentTextField.text block:^(Post *post) {
            NSLog(@"Block: %@", post);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    [progressView dismiss];
//        [post create:self.locationManager.location withContent:self.contentTextField.text withBlock:^(CGFloat progress) {
//            [progressView setProgress:progress];
//        } completion:^(BOOL success, NSError *error) {
//            [progressView dismiss];
//            if (success) {
//                [self.navigationController popViewControllerAnimated:YES];
//            } else {
//                NSLog(@"ERROR: %@", error);
//            }
//        }];
//        } else {
//            NSLog(@"No Location");
//        }
}


@end
