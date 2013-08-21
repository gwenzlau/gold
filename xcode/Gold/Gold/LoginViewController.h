//
//  LoginViewController.h
//  Gold
//
//  Created by Grant Wenzlau on 8/21/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButton:(id)sender;


@end
