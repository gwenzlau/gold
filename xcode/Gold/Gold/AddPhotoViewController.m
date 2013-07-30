//
//  AddPhotoViewController.m
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "Post.h"
#import "ProgressView.h"
#import <CoreLocation/CoreLocation.h>

@interface AddPhotoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong) CLLocationManager *locationManager;
@end

@implementation AddPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [self saveButton];
    self.locationManager = [[CLLocationManager alloc] init];
  //  self.locationManager.delegate = self;
}

- (UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                         target:self
                                                         action:@selector(save:)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"photoCell"]) {
        [self promptForPhoto];
    }
}

- (void)promptForPhoto {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary |
    UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerController.sourceType |=UIImagePickerControllerSourceTypeCamera;
    }
    
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    
    [self presentViewController:pickerController
                       animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
    [self getLocation];
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

- (void)save:(id)sender {
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
  //  locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    [locationManager startUpdatingLocation];
    
    [self getLocation];
    NSArray *locations;
    //CLLocation *location = [locations objectAtIndex:0];
   // CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    CLLocation * location = [locationManager location];
    
    Post *post = [[Post alloc] init];
    post.content = self.contentTextField.text;
    post.photoData = UIImagePNGRepresentation(self.imageView.image);
    
    [self.view endEditing:YES];
    
    ProgressView *progressView = [ProgressView presentInWindow:self.view.window];
    if (location) {
        [post saveWithProgressAtLocation:self.locationManager.location withBlock:^(CGFloat progress) {
            [progressView setProgress:progress];
        } completion:^(BOOL success, NSError *error) {
            [progressView dismiss];
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"ERROR: %@", error);
            }
        }];
    } else {
        NSLog(@"No Location");
    }
 }

@end
