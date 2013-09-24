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
#import "GAI.h"
#import <Crashlytics/Crashlytics.h>
#import "FCModel.h"
#import "Venue.h"

@implementation AppDelegate
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self _configureAFNetworking];

#if (!DEBUG)
    [self _configureGoogleAnalytics];
#endif

    [self _configureDatabase];

    [self _updateVenueData];

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

- (void)_configureDatabase
{
    NSString *dbPath = [[self _applicationDocumentsDirectory] stringByAppendingPathComponent:@"drink.sqlite3"];
    NSLog(@"INFO: DB Path: %@", dbPath);

    // New DB on every launch for testing (comment out for persistence testing)
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:NULL];

    [FCModel openDatabaseAtPath:dbPath withSchemaBuilder:^(FMDatabase *db, int *schemaVersion) {
        [db setCrashOnErrors:YES];
        db.traceExecution = YES; // Log every query (useful to learn what FCModel is doing or analyze performance)
        [db beginTransaction];

        void (^failedAt)(int statement) = ^(int statement){
            [db rollback];
            NSAssert3(0, @"Migration statement %d failed, code %d: %@", statement, db.lastErrorCode, db.lastErrorMessage);
        };

        if (*schemaVersion < 1) {
            if (! [db executeUpdate:
                   @"CREATE TABLE Checkin ("
                   @"    id           INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    name         TEXT NOT NULL DEFAULT '',"
                   @"    latitude     REAL,"
                   @"    longitude    REAL,"
                   @"    drink_id     INTEGER NOT NULL,"
                   @"    venue_id     INTEGER NOT NULL,"
                   @"    createdTime  INTEGER NOT NULL,"
                   @"    modifiedTime INTEGER NOT NULL"
                   @");"
                   ]) failedAt(1);
            if (! [db executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS name ON Checkin (name);"]) failedAt(2);

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
                   ]) failedAt(1);
            if (! [db executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS name ON Venue (name);"]) failedAt(2);

            *schemaVersion = 1;
        }

        [db commit];
    }];

    // Put some data in the table
    Checkin *p = [Checkin new];
    p.name = @"Bob";
    p.createdTime = [NSDate date];
    p.modifiedTime = [NSDate date];
    [p save];
}

- (void)_configureGoogleAnalytics
{
    // setup Google Analytics
    [GAI sharedInstance].dispatchInterval = 20;
    [GAI sharedInstance].debug = YES;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-37810022-1"];
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
