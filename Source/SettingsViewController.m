//
//  Created by Chris Kau on 10/4/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "SettingsViewController.h"
#import "ISO8601DateFormatter.h"
#import "Checkin.h"
#import "Drink.h"
#import "User.h"
#import "Venue.h"
#import "TMCache.h"

@implementation SettingsViewController

- (id)init
{
    self = [super initWithNibName:@"SettingsView" bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor darkGrayColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


#pragma mark Action methods

- (IBAction)importVenues:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"venues" ofType:@"json"];
    NSData *venueData = [[NSData alloc] initWithContentsOfFile:path];

    if (venueData) {
        ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];

        id JSON = [NSJSONSerialization JSONObjectWithData:venueData options:0 error:nil];

        for (NSDictionary *dict in JSON) {
            NSNumber *venue_id = [dict valueForKey:@"id"];

            Venue *venue = [Venue instanceWithPrimaryKey:venue_id];
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
    }
}

- (IBAction)importDrinks:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"drinks" ofType:@"json"];
    NSData *drinkData = [[NSData alloc] initWithContentsOfFile:path];
    
    if (drinkData) {
        id JSON = [NSJSONSerialization JSONObjectWithData:drinkData options:0 error:nil];

        for (NSDictionary *dict in JSON) {
            Drink *drink = [Drink instanceWithPrimaryKey:[dict valueForKey:@"id"]];
            drink.name = [dict valueForKey:@"name"];
            drink.creator = [dict valueForKey:@"created_by"];
            // TODO:            drink.recipe = [dict valueForKey:@"recipe_raw"];
            drink.createdTime = [NSDate date];
            drink.modifiedTime = [NSDate date];
            [drink save];

            // download images
            NSArray *images = [dict valueForKey:@"images"];
            if ((images != nil) && ([images count] > 0)) {
                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                sessionConfiguration.allowsCellularAccess = YES;
                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

                NSString *imageURL = [[images valueForKeyPath:@"image.image"] objectAtIndex:0];
                NSURL *url = [NSURL URLWithString:[@"http://whatdididrink.com" stringByAppendingPathComponent:imageURL]];

                NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [[TMCache sharedCache] setObject:image forKey:[NSString stringWithFormat:@"%lld", drink.id]];
                }];
                [dataTask resume];
            }
        }
    }
}

- (IBAction)importCheckins:(id)sender
{
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"checkins" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];

    if (data) {
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        User *user = [User currentUser];

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

- (IBAction)deleteAllLocalData:(id)sender
{
    [[FCModel databaseQueue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM Checkin"];
        [db executeUpdate:@"DELETE FROM Venue"];
        [db executeUpdate:@"DELETE FROM Drink"];

        // clear the cache
        [[TMCache sharedCache] removeAllObjects];
    }];
}

@end
