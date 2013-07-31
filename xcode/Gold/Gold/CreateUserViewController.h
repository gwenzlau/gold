//
//  CreateUserViewController.h
//  Gold
//
//  Created by Grant Wenzlau on 7/30/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface CreateUserViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)signUp:(id)sender;

@end


@protocol CreateUserViewControllerDelegate <NSObject>

- (void)viewController:(CreateUserViewController *)viewController didCreateUser:(User *)user;

@end

