//
//  LoginViewController.m
//  Gold
//
//  Created by Grant Wenzlau on 8/21/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Login", nil);
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

#pragma mark - IBAction

- (IBAction)loginButton:(id)sender {
    [User loginUser:self.emailTextField email:self.emailTextField.text password:self.passwordTextField.text
              block:^(User *user) {
        NSLog(@"User logged in!");
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self loginButton:textField];
    }
    
    return YES;
}
@end
