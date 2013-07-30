//
//  CreateUserViewController.m
//  Gold
//
//  Created by Grant Wenzlau on 7/24/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "CreateUserViewController.h"
#import "User.h"

@interface CreateUserViewController ()

@end

@implementation CreateUserViewController

#pragma mark  - UIViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Signup", nil);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


- (IBAction)signUp:(id)sender {
    [User createUserWithUsername:self.signatureTextField.text email:self.emailTextField.text password:self.passwordTextField.text block:^(User *user) {
        NSLog(@"User: %@", user);
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordTextField]) {
        [self.signatureTextField becomeFirstResponder];
    } else {
        [self signUp:textField];
    }
    
    return YES;
}
@end
