//
//  DetailViewController.m
//  Gold
//
//  Created by Grant Wenzlau on 7/19/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()
@property (nonatomic, strong) Post *post;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation DetailViewController

- (id)initWithPost:(Post *)post {
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        self.post = post;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"ReMark"];
 
    NSURL *imageUrl = [NSURL URLWithString:self.post.largeUrl];
    [self.imageView setImageWithURL:imageUrl];
    self.imageView.clipsToBounds = YES;
    
    self.contentLabel.text = self.post.content;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setContentLabel:nil];
    
    [super viewDidUnload];
}

    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
