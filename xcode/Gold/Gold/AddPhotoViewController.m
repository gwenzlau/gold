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

@interface AddPhotoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AddPhotoViewController



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

//- (void)save:(id)sender {
//    Post *post = [[Post alloc] init];
//    post.content = self.contentTextView.text;
//    post.photoData = UIImagePNGRepresentation(self.imageView.image);
//    
//    [self.view endEditing:YES];
//    
//    ProgressView *progressView = [ProgressView presentInWindow:self.view.window];
//    
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
