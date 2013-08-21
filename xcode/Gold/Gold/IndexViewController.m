//
//  IndexViewController.m
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//
#import "APIClient.h"
#import <CoreLocation/CoreLocation.h>
#import "IndexViewController.h"
#import "Post.h"
#import "Notifications.h"
#import "SSPullToRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "CreateUserViewController.h"
#import "LoginViewController.h"
#import "ISO8601DateFormatter.h"

static CLLocationDistance const kMapRegionSpanDistance = 5000;

@interface IndexViewController () <CLLocationManagerDelegate>
@property (strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@end

@implementation IndexViewController

@synthesize posts = _posts;
@synthesize locationManager = _locationManager;
@synthesize pullToRefreshView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Marko";
    self.navigationItem.leftBarButtonItem = [self photoButton];
    self.navigationItem.rightBarButtonItem = [self noteButton];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    [self.locationManager startUpdatingLocation];
    
    [self listenForCreatedPosts];
    [self loadPosts: [self getLocation]];
    
    if (![[APIClient sharedClient] isAuthorized]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.locationManager startUpdatingLocation];
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

- (void)listenForCreatedPosts {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postCreated:)
                                                 name:PostCreatedNotification
                                               object:nil];
}

- (UIBarButtonItem *)photoButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPhoto:)];
}

- (UIBarButtonItem *)noteButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addNote:)];
}

- (void)refresh {
    [self.pullToRefreshView startLoading];
    [self loadPosts: [self getLocation]];
    [self.pullToRefreshView finishLoading];
}


- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

-(CLLocation *) getLocation{
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    [locationManager startUpdatingLocation];
    CLLocation * location = [locationManager location];
    return location;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //[self loadPosts: [self getLocation]];
   // CLLocation *location = [locations objectAtIndex:0];
    CLLocation * location = [manager location];
    
    if (location) {
        NSLog(@"You are at %@", location);
        [Post fetchNearbyPosts:location withBlock:^(NSArray *posts, NSError *error) {
            if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Weird. Couldn't find any posts around here. You should start something.", nil) message:[error localizedFailureReason] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
            } else {
                self.posts = posts;
        [self.tableView reloadData];
       
        [manager stopUpdatingLocation];
    }
        }];
        } else {
        NSLog(@"No Location");
    }
}

- (void) loadPosts:(CLLocation *)location {
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    [locationManager startUpdatingLocation];
    
    [Post fetchNearbyPosts:location
                 withBlock:^(NSArray *posts, NSError *error) {
                    
        if (posts) {
            NSLog(@"Recieved %d posts", posts.count);
            NSLog(@"And those posts are located near %@", location);
            self.posts = [NSMutableArray arrayWithArray:posts];
            [self.tableView reloadData];
            [self.tableView setNeedsLayout];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"ERROR"
                                        message:@"Couldn't fetch nearby posts."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
                 }];
}




- (void)addPhoto:(id)sender {
    UIStoryboard *addPhotoStoryboard = [UIStoryboard storyboardWithName:@"AddPhotoStoryboard"
                                                                 bundle:nil];

    id vc = [addPhotoStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNote:(id)sender {
    UIStoryboard *addNoteStoryboard = [UIStoryboard storyboardWithName:@"AddNoteStoryboard"
                                                                 bundle:nil];
    
    id vc = [addNoteStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postCreated:(NSNotification *)notification {
    [self.posts insertObject:notification.object atIndex:0];
//    NSIndexPath *firstItemPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:firstItemPath]
//                          withRowAnimation:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.posts objectAtIndex:indexPath.row];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"EEE, d MMM yyyy, hh:mm aaa"];
//    NSDate *date = nil;
//    
//        date = [NSDate date];
//        NSString *dateString = [dateFormatter stringFromDate:date];
//        cell.detailTextLabel.text = dateString;
   // CLLocationCoordinate2DMake(post.location.coordinate.latitude, post.location.coordinate.longitude);
 //   NSLog(NSString stringWithFormat:(%f, %f), post.location.coordinate.latitude, post.location.coordinate.longitude);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = post.content;
    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:9];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"posted on %@ at (%f, %f)",
                                 post.timestamp,
                                 post.location.coordinate.latitude,
                                 post.location.coordinate.longitude];
    
    cell.imageView.image = [UIImage imageWithData:post.photoData];
   
//    NSURL *imageUrl = [NSURL URLWithString:post.thumbnailUrl];
//    UIImage *defaultImage = [UIImage imageNamed: @"marko-nophoto.png"];
//    
//    if (imageUrl) {
//        [cell.imageView setImageWithURL:imageUrl];
//    } else {
//        cell.imageView.image = nil;
//    }
}


#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
 //    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//    Post *selectedPost = [self.posts objectAtIndex:indexPath];
//    DetailViewController *postVC = [[DetailViewController alloc] initWithPost:selectedPost];
 //   [self.navigationController pushViewController:detailViewController animated:YES];
    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.posts objectAtIndex:indexPath.row];
    return MAX([post.content sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(280.0f, CGFLOAT_MAX)].height, tableView.rowHeight);
}
@end
