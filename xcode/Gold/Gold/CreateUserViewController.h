//
//  CreateUserViewController.h
//  Gold
//
//  Created by Grant Wenzlau on 7/24/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface CreateUserViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)signUp:(id)sender;

@end
