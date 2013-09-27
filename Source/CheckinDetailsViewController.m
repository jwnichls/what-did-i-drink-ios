//
//  Created by Chris Kau on 8/13/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "CheckinDetailsViewController.h"
#import "Checkin.h"
#import "Drink.h"
#import "Venue.h"

@implementation CheckinDetailsViewController {
}

- (id)init
{
    self = [super initWithNibName:@"CheckinDetailsView" bundle:nil];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Checkin Details";

    Drink *drink = [Drink instanceWithPrimaryKey:@(_checkin.drink_id)];
    self.drinkLabel.text = drink.name;
    self.creatorLabel.text = drink.creator;

    Venue *venue = [Venue instanceWithPrimaryKey:@(_checkin.venue_id)];
    self.venueLabel.text = venue.name;
    self.notesTextView.text = _checkin.notes;
}

- (void)setCheckin:(Checkin *)checkin
{
    _checkin = checkin;

    self.navigationItem.title = _checkin.name;
}

@end
