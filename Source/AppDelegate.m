//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationLogger.h"
#import "Checkin.h"
#import "CheckinsViewController.h"
#import "Client.h"
#import "Drink.h"
#import "FCModel.h"
#import "GAI.h"
#import "ISO8601DateFormatter.h"
#import <Crashlytics/Crashlytics.h>
#import "User.h"
#import "Venue.h"

@implementation AppDelegate {
    CLLocationManager *_locationManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self _configureAFNetworking];

#if (!DEBUG)
    [self _configureGoogleAnalytics];
#endif

    [self _configureLocationManager];

    [self _configureDatabase];

//    [self _updateVenueData];
//    [self _importDrinkData];
//    [self _importCheckinData];

    [self _customizeAppearance];

    // checkins
    CheckinsViewController *checkinsViewController = [[CheckinsViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:checkinsViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    [self _configureCrashlytics];

    return YES;
}

- (CLLocationManager *)locationManager
{
    return _locationManager;
}


#pragma mark Private methods

- (NSString *)_applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (void)_configureAFNetworking
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
}

- (void)_configureCrashlytics
{
    [Crashlytics startWithAPIKey:@"d428b1fbc4aadc4e5f99cce2c43724eb9e62055e"];
}


#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

- (void)_configureDatabase
{
    NSString *dbPath = [[self _applicationDocumentsDirectory] stringByAppendingPathComponent:@"drink.sqlite3"];
    NSLog(@"INFO: DB Path: %@", dbPath);

    // New DB on every launch for testing (comment out for persistence testing)
//    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:NULL];

    [FCModel openDatabaseAtPath:dbPath withSchemaBuilder:^(FMDatabase *db, int *schemaVersion) {
        [db setCrashOnErrors:YES];
        db.traceExecution = YES; // Log every query (useful to learn what FCModel is doing or analyze performance)
        [db beginTransaction];

        void (^failedAt)(int statement) = ^(int statement){
            [db rollback];
            NSAssert3(0, @"Migration statement %d failed, code %d: %@", statement, db.lastErrorCode, db.lastErrorMessage);
        };

        if (*schemaVersion < 1) {
            // create the User table
            if (! [db executeUpdate:
                   @"CREATE TABLE User ("
                   @"    id           INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    name         TEXT NOT NULL DEFAULT '',"
                   @"    emailAddress TEXT NOT NULL DEFAULT '',"
                   @"    imageURL     TEXT,"
                   @"    createdTime  INTEGER NOT NULL,"
                   @"    modifiedTime INTEGER NOT NULL"
                   @");"
                   ]) failedAt(1);
            if (! [db executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS name ON User (name);"]) failedAt(2);

            // create the Drink table
            if (! [db executeUpdate:
                   @"CREATE TABLE Drink ("
                   @"    id           INTEGER PRIMARY KEY,"
                   @"    name         TEXT NOT NULL DEFAULT '',"
                   @"    creator      TEXT DEFAULT '',"
                   @"    createdTime  INTEGER NOT NULL,"
                   @"    modifiedTime INTEGER NOT NULL"
                   @");"
                   ]) failedAt(3);
            if (! [db executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS name ON Drink (name);"]) failedAt(4);

            // create the Checkin table
            if (! [db executeUpdate:
                   @"CREATE TABLE Checkin ("
                   @"    id           INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    name         TEXT NOT NULL DEFAULT '',"
                   @"    latitude     REAL,"
                   @"    longitude    REAL,"
                   @"    user_id      INTEGER NOT NULL,"
                   @"    drink_id     INTEGER NOT NULL,"
                   @"    venue_id     INTEGER NOT NULL,"
                   @"    notes        TEXT DEFAULT '',"
                   @"    createdTime  INTEGER NOT NULL,"
                   @"    modifiedTime INTEGER NOT NULL"
                   @");"
                   ]) failedAt(5);
            if (! [db executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS name ON Checkin (name);"]) failedAt(6);

            // create the Venue table
            if (! [db executeUpdate:
                   @"CREATE TABLE Venue ("
                   @"    id           INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    name         TEXT NOT NULL DEFAULT '',"
                   @"    address      TEXT,"
                   @"    postalCode   TEXT,"
                   @"    city         TEXT,"
                   @"    state        TEXT,"
                   @"    latitude     REAL,"
                   @"    longitude    REAL,"
                   @"    createdTime  INTEGER NOT NULL,"
                   @"    modifiedTime INTEGER NOT NULL"
                   @");"
                   ]) failedAt(7);
            if (! [db executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS name ON Venue (name);"]) failedAt(8);


            // create function to calculate distance in km between 2 locations
            // distance function for SQLite: http://www.thismuchiknow.co.uk/?p=71
            [db makeFunctionNamed:@"distance" maximumArguments:4 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
                // check that we have four arguments (lat1, lon1, lat2, lon2)
                assert(argc == 4);

                // check that all four arguments are non-null
                if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
                    sqlite3_result_null(context);
                    return;
                }

                // get the four argument values
                double lat1 = sqlite3_value_double(argv[0]);
                double lon1 = sqlite3_value_double(argv[1]);
                double lat2 = sqlite3_value_double(argv[2]);
                double lon2 = sqlite3_value_double(argv[3]);

                // convert lat1 and lat2 into radians now, to avoid doing it twice below
                double lat1rad = DEG2RAD(lat1);
                double lat2rad = DEG2RAD(lat2);

                // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
                // 6378.1 is the approximate radius of the earth in kilometres
                sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
            }];


            // increase the schema version
            *schemaVersion = 1;
        }

        [db commit];
    }];


    // create a default user
    [self _createDefaultUser];
}

- (void)_configureGoogleAnalytics
{
    // setup Google Analytics
    [GAI sharedInstance].dispatchInterval = 20;
    [GAI sharedInstance].debug = YES;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-37810022-1"];
}

- (void)_configureLocationManager
{
    if ([CLLocationManager locationServicesEnabled] == NO) {
        // TODO: ask the user to enable location services for us
    }
    else {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        [_locationManager startUpdatingLocation];
    }
}

- (void)_createDefaultUser
{
    if ([[User allInstances] count] == 0) {
        User *user = [User new];
        user.name = @"Default";
        user.createdTime = [NSDate date];
        user.modifiedTime = [NSDate date];
        [user save];
    }
}

- (void)_customizeAppearance
{
    // customize the appearance of the navigation bar
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *titleTextAttributes = @{
                                          UITextAttributeFont : [UIFont systemFontOfSize:22.0f],
                                          UITextAttributeTextColor : [UIColor colorWithRed:0.988 green:0.988 blue:0.988 alpha:1.0]
                                         };
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    [[UINavigationBar appearance] setBarTintColor:RGB(84.0f, 192.0f, 255.0f)];

    // customize the appearance of the tool bar
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar.png"]];
//    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithHue:202 saturation:67 brightness:100 alpha:1.0]];
}

- (void)_importCheckinData
{
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"checkins" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];

    if (data) {
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        User *user = [[User allInstances] firstObject];

        for (NSDictionary *dict in JSON) {
            Checkin *checkin = [Checkin new];
            checkin.user_id = user.id;
            // TODO: this should not be necessary, we should only save the id of the drink
            Drink *drink = [Drink instanceWithPrimaryKey:[dict valueForKey:@"drink_id"]];
            checkin.name = drink.name;
//            id location = [dict valueForKey:@"location"];
//            checkin.longitude = 0;
//            checkin.latitude = 0;
            id venue_id = [dict valueForKey:@"venue_id"];
            if (venue_id != [NSNull null]) checkin.venue_id = [venue_id integerValue];
            id drink_id = [dict valueForKey:@"drink_id"];
            if (drink_id && drink_id != [NSNull null]) checkin.drink_id = [drink_id integerValue];
            checkin.notes = [dict valueForKey:@"notes"];

            // convert and import 'created_at' from ISO8601
            NSDate *createdTime = [dateFormatter dateFromString:[dict valueForKey:@"created_at"]];
            checkin.createdTime = createdTime;

            // convert and import 'created_at' from ISO8601
            NSDate *modifiedTime = [dateFormatter dateFromString:[dict valueForKey:@"updated_at"]];
            checkin.modifiedTime = modifiedTime;
            [checkin save];
        }
    }
}

- (void)_importDrinkData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"drinks" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];

    if (data) {
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        for (NSDictionary *dict in JSON) {
            Drink *drink = [Drink instanceWithPrimaryKey:[dict valueForKey:@"id"]];
            drink.name = [dict valueForKey:@"name"];
            drink.creator = [dict valueForKey:@"created_by"];
            drink.createdTime = [NSDate date];
            drink.modifiedTime = [NSDate date];
            [drink save];
        }
    }
}

- (void)_updateVenueData
{
    [[Client sharedClient] allVenuesWithCompletionHandler:^(id JSON, NSError *error) {
//        NSArray *venues = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:NULL];

        for (NSDictionary *dict in JSON) {
            Venue *venue = [Venue new];
            venue.name = [dict valueForKey:@"name"];
            venue.address = [dict valueForKey:@"address"];
            venue.city = [dict valueForKey:@"city"];
            venue.postalCode = [dict valueForKey:@"postalCode"];
            venue.state = [dict valueForKey:@"state"];
            venue.longitude = [[dict valueForKey:@"lng"] floatValue];
            venue.latitude = [[dict valueForKey:@"lat"] floatValue];
//            venue.createdTime = [dict valueForKey:@"created_at"];
//            venue.modifiedTime = [dict valueForKey:@"modified_at"];
            [venue save];
        }
    }];
}

@end
