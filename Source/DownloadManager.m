//
//  Created by Chris Kau on 1/18/14.
//  Copyright (c) 2014 N/A. All rights reserved.
//

#import "DownloadManager.h"
#import "Checkin.h"
#import "Client.h"
#import "Drink.h"
#import "ISO8601DateFormatter.h"
#import "Venue.h"

// notifications
NSString * const CheckinsDidUpdateNotification = @"CheckinsDidUpdateNotification";
NSString * const DrinksDidUpdateNotification = @"DrinksDidUpdateNotification";
NSString * const VenuesDidUpdateNotification = @"VenuesDidUpdateNotification";


@implementation DownloadManager

+ (id)sharedManager
{
    static dispatch_once_t onceQueue;
    static DownloadManager *downloadManager = nil;
    
    dispatch_once(&onceQueue, ^{
        downloadManager = [[self alloc] init];
    });
    
    return downloadManager;
}

- (void)updateCheckins
{
    // get timestamp of last update
    NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] dateForLastCheckinsUpdate];
    if (lastUpdate == nil) lastUpdate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSLog(@"INFO: Fetching all checkins since %@.", lastUpdate);

    // fetch venue data from from servers
    [[Client sharedClient] allCheckinsSinceDate:lastUpdate completion:^(id JSON, NSError *error) {
        if ((error == nil) && (JSON != nil)) {
            // TODO: process checkins data (create/update based on updated_at)
            for (NSDictionary *dict in JSON) {
                NSLog(@"<user_id: %@, location: %@, created_at: %@>", [dict objectForKey:@"user_id"], [dict objectForKey:@"location"], [dict objectForKey:@"created_at"]);
            }

            // update last updated timestamp
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastCheckinsUpdateKey"];

            // send notification
            [[NSNotificationCenter defaultCenter] postNotificationName:CheckinsDidUpdateNotification object:nil];
        }
    }];
}

- (void)updateDrinks
{
    // get timestamp of last update
    NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] dateForLastDrinksUpdate];
    if (lastUpdate == nil) lastUpdate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSLog(@"INFO: Fetching all drinks since %@.", lastUpdate);

    // fetch drinks data from from servers
    [[Client sharedClient] allDrinksSinceDate:lastUpdate completion:^(id JSON, NSError *error) {
        if ((error == nil) && (JSON != nil)) {
            // TODO: process drinks data (create/update based on updated_at)
            for (NSDictionary *dict in JSON) {
                id drink_id = [dict objectForKey:@"id"];
                Drink *drink = [Drink instanceWithPrimaryKey:drink_id createIfNonexistent:YES];
                drink.name = [dict objectForKey:@"name"];
                drink.creator = [dict objectForKey:@"created_by"];
                [drink save];
            }

            // update last updated timestamp
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastDrinksUpdateKey"];

            // send notification
            [[NSNotificationCenter defaultCenter] postNotificationName:DrinksDidUpdateNotification object:nil];
        }
    }];
}

- (void)updateVenues
{
    // get timestamp of last update
    NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] dateForLastVenuesUpdate];
    if (lastUpdate == nil) lastUpdate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSLog(@"INFO: Fetching all venues since %@.", lastUpdate);

    // fetch venue data from from servers
    [[Client sharedClient] allVenuesSinceDate:lastUpdate completion:^(id JSON, NSError *error) {
        if ((error == nil) && (JSON != nil)) {
            // TODO: process venue data (create/update based on updated_at)
            ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];

            for (NSDictionary *dict in JSON) {
                Venue *venue = [Venue new];
                venue.name = [dict valueForKey:@"name"];
                venue.address = [dict valueForKey:@"address"];
                venue.city = [dict valueForKey:@"city"];
                venue.postalCode = [dict valueForKey:@"postalCode"];
                venue.state = [dict valueForKey:@"state"];
                venue.longitude = [[dict valueForKey:@"lng"] floatValue];
                venue.latitude = [[dict valueForKey:@"lat"] floatValue];

                // convert and import 'created_at' from ISO8601
                NSDate *createdTime = [dateFormatter dateFromString:[dict valueForKey:@"created_at"]];
                venue.createdTime = createdTime;

                // convert and import 'created_at' from ISO8601
                NSDate *modifiedTime = [dateFormatter dateFromString:[dict valueForKey:@"updated_at"]];
                venue.modifiedTime = modifiedTime;

                [venue save];
            }

            // update last updated timestamp
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastVenuesUpdateKey"];

            // send notification
            [[NSNotificationCenter defaultCenter] postNotificationName:VenuesDidUpdateNotification object:nil];
        }
    }];
}

@end
