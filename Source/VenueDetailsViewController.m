//
//  Created by Chris Kau on 6/5/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "VenueDetailsViewController.h"
#import "Checkin.h"
#import "Client.h"
#import "GAI.h"

@implementation VenueDetailsViewController {
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Venue Details";

    self.view.backgroundColor = TABLE_VIEW_BACKGROUND_COLOR;
    [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"venue.png"]]];
}

- (void)setVenue:(id)venue
{
    _venue = venue;
}

@end
