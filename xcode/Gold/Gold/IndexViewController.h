//
//  IndexViewController.h
//  Gold
//
//  Created by Grant Wenzlau on 7/18/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefresh.h"
#import <CoreLocation/CoreLocation.h>


@interface IndexViewController : UITableViewController < SSPullToRefreshViewDelegate, CLLocationManagerDelegate>

@end
