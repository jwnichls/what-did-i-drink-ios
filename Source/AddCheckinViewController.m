//
//  Created by Chris Kau on 1/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "AddCheckinViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "GAI.h"
//#import "Drink.h"
#import "Checkin.h"
#import "User.h"
#import "Venue.h"

// TODO:
// scroll up so that the text field the user is entering information into is always at the top

@implementation AddCheckinViewController {
    CLLocationManager *_locationManager;
    NSArray *_venueNames;
}

- (id)init
{
    self = [super initWithNibName:@"AddCheckinView" bundle:nil];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Add Checkin";

    _locationManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] locationManager];

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

    // venue picker
    self.venuePicker.dataSource = self;
    self.venuePicker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CLLocationDegrees latitude = _locationManager.location.coordinate.latitude;
	CLLocationDegrees longitude = _locationManager.location.coordinate.longitude;

    [[FCModel databaseQueue] inDatabase:^(FMDatabase *db) {
        CGFloat distance = 1500.0;
        FMResultSet *resultSet = [db executeQueryWithFormat:@"SELECT name, city, distance(latitude, longitude, %f, %f) AS dist FROM Venue WHERE dist < %f ORDER BY dist", latitude, longitude, distance];

        // TODO: handle if we have no location data and therefore no venues

        NSMutableArray *names = [NSMutableArray array];
        while ([resultSet next]) {
            NSString *name = [NSString stringWithFormat:@"%@ %@ (%.0f km)", [resultSet stringForColumnIndex:0], [resultSet stringForColumnIndex:1], [resultSet doubleForColumnIndex:2]];
            [names addObject:name];
        }

        _venueNames = names;
        [self.venuePicker reloadAllComponents];
    }];
}


#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_venueNames count];
}


#pragma mark UIPickerViewDelegate methods

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _venueNames[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.venueTextField.text = _venueNames[row];
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
    // TODO: create checkin, venue, and drink; save all, with their relationships
    User *user = [[User allInstances] firstObject];

    Checkin *checkin = [Checkin new];
    checkin.user_id = user.id;
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
