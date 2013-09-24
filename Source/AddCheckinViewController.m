//
//  Created by Chris Kau on 1/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "AddCheckinViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GAI.h"
//#import "Drink.h"
#import "Checkin.h"

// TODO:
// scroll up so that the text field the user is entering information into is always at the top

@implementation AddCheckinViewController {
    CLLocationManager *_locationManager;
}

- (id)init
{
    self = [super initWithNibName:@"AddCheckinView" bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Add Checkin";

    if ([CLLocationManager locationServicesEnabled] == NO) {
        // TODO: ask the user to enable location services for us
    }
    else {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        [_locationManager startUpdatingLocation];
    }

    // drink name
    self.drinkTextField.delegate = self;
    self.drinkTextField.placeholder = NSLocalizedString(@"Name", @"");
    self.drinkTextField.backgroundColor = [UIColor whiteColor];
    self.drinkTextField.returnKeyType = UIReturnKeyNext;
    [self.drinkTextField becomeFirstResponder];

    // venue name
    self.venueTextField.delegate = self;
    self.venueTextField.placeholder = NSLocalizedString(@"Venue", @"");
    self.venueTextField.backgroundColor = [UIColor whiteColor];
    self.venueTextField.returnKeyType = UIReturnKeyDone;
}


#pragma mark Private methods

- (IBAction)cancel:(id)sender
{
    if ((_delegate) && ([_delegate respondsToSelector:@selector(addCheckinViewControllerDidCancel)])) {
        [_delegate addCheckinViewControllerDidCancel];
    }
}

- (IBAction)done:(id)sender
{
    Checkin *checkin = [Checkin new];
    checkin.name = self.drinkTextField.text;
    checkin.longitude = _locationManager.location.coordinate.longitude;
    checkin.latitude = _locationManager.location.coordinate.latitude;
    checkin.createdTime = [NSDate date];
    checkin.modifiedTime = [NSDate date];
    [checkin save];

    if ((_delegate) && ([_delegate respondsToSelector:@selector(addCheckinViewControllerDidFinish)])) {
        [_delegate addCheckinViewControllerDidFinish];
    }
}

@end
