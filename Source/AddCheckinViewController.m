//
//  Created by Chris Kau on 1/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "AddCheckinViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "GAI.h"
#import "Drink.h"
#import "Checkin.h"
#import "TMCache.h"
#import "User.h"
#import "Venue.h"


@interface VenueStub : NSObject
@property (nonatomic, assign) int64_t id;
@property (nonatomic, copy) NSString *name;
@end

@implementation VenueStub
@end


@implementation AddCheckinViewController {
    CLLocationManager *_locationManager;
    NSArray *_venueNames;
    NSUInteger _selectedRow;
    UIImage *_image;
}

- (id)init
{
    self = [super initWithNibName:@"AddCheckinView" bundle:nil];
    if (self) {
        _selectedRow = -1;
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
        FMResultSet *resultSet = [db executeQueryWithFormat:@"SELECT id, name, city, distance(latitude, longitude, %f, %f) AS dist FROM Venue WHERE dist < %f ORDER BY dist", latitude, longitude, distance];

        // TODO: handle if we have no location data and therefore no venues

        NSMutableArray *names = [NSMutableArray array];
        while ([resultSet next]) {
            NSString *name = [NSString stringWithFormat:@"%@ %@ (%.0f km)", [resultSet stringForColumnIndex:1], [resultSet stringForColumnIndex:2], [resultSet doubleForColumnIndex:3]];
            VenueStub *stub = [[VenueStub alloc] init];
            stub.id = [resultSet intForColumnIndex:0];
            stub.name = name;
            [names addObject:stub];
        }

        _venueNames = names;

        [self.venuePicker reloadAllComponents];
        [self.venuePicker selectRow:0 inComponent:0 animated:NO];
        _selectedRow = 0;

        if ([_venueNames count] > 0) {
            VenueStub *stub = _venueNames[0];
            self.venueTextField.text = stub.name;
        }
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
    VenueStub *stub = _venueNames[row];
    return stub.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedRow = row;
    VenueStub *stub = _venueNames[row];
    self.venueTextField.text = stub.name;
}


#pragma mark UIImagePickerViewControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    });

    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark Action methods

- (IBAction)cancel:(id)sender
{
    _image = nil;

    if ((_delegate) && ([_delegate respondsToSelector:@selector(addCheckinViewControllerDidCancel)])) {
        [_delegate addCheckinViewControllerDidCancel];
    }
}

- (IBAction)done:(id)sender
{
    User *user = [[User allInstances] firstObject];

    Drink *drink = [Drink firstInstanceWhere:@"name = ?", self.drinkTextField.text];
    if (drink == nil) {
        drink = [Drink new];
        drink.name = self.drinkTextField.text;
        drink.createdTime = [NSDate date];
        drink.modifiedTime = [NSDate date];
        [drink save];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            [[TMCache sharedCache] setObject:_image forKey:[NSString stringWithFormat:@"%lld", drink.id]];
        });
    }

    int64_t venue_id = 0;
    if (([_venueNames count] > 0) && ([_venueNames count] >= _selectedRow)) {
        VenueStub *stub = _venueNames[_selectedRow];
        venue_id = stub.id;
    }

    Checkin *checkin = [Checkin new];
    checkin.user_id = user.id;
    checkin.name = self.drinkTextField.text;
    checkin.longitude = _locationManager.location.coordinate.longitude;
    checkin.latitude = _locationManager.location.coordinate.latitude;
    checkin.drink_id = drink.id;
    checkin.venue_id = venue_id;
    checkin.createdTime = [NSDate date];
    checkin.modifiedTime = [NSDate date];
    [checkin save];

    _image = nil;

    if ((_delegate) && ([_delegate respondsToSelector:@selector(addCheckinViewControllerDidFinish)])) {
        [_delegate addCheckinViewControllerDidFinish];
    }
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerControllerSourceType sourceType = NULL;
#if TARGET_IPHONE_SIMULATOR
    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    sourceType = UIImagePickerControllerSourceTypeCamera;
#endif

    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}

@end
