//
//  Created by Chris Kau on 1/26/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "TimelineViewController.h"
#import "AppDelegate.h"
#import "Client.h"
#import "DrinkDetailsViewController.h"
#import "ISO8601DateFormatter.h"

@implementation TimelineViewController {
    __weak AppDelegate *appDelegate;

    ISO8601DateFormatter *_dateFormatter;

    UITableView *_tableView;
    NSArray *_events;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Timeline", @"Timeline");
        self.tabBarItem.image = [UIImage imageNamed:@"timeline"];
        CGRect frame = CGRectMake(0.0, 0.0, 320.0, 456.0);
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];

        _dateFormatter = [[ISO8601DateFormatter alloc] init];

        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Timeline";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // load all drinks asynchroneously from server
    [[Client sharedClient] allDrinksWithCompletionHandler:^(id drinksJSON, NSError *error1) {
        appDelegate._drinks = [drinksJSON mutableCopy];

        // load timeline asynchroneously from server
        [[Client sharedClient] timelineWithCompletionHandler:^(id eventsJSON, NSError *error2) {
            _events = eventsJSON;
            [_tableView reloadData];
        }];
    }];
}


#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSDictionary *event = [_events objectAtIndex:indexPath.row];

    NSString *eventType = [event valueForKey:@"type"];
    NSString *drinkName = [event valueForKeyPath:@"drink.name"];
    NSString *userName = [event valueForKeyPath:@"user.full_name"];

    NSString *text = nil;

    // drink was added to the library
    if ([eventType isEqualToString:@"AddDrink"]) {
        text = [NSString stringWithFormat:@"'%@' was added to the list of drinks", drinkName];
    }
    // a drink in the library was updated
    else if ([eventType isEqualToString:@"EditDrink"]) {
        text = [NSString stringWithFormat:@"The recipe for '%@' was updated", drinkName];
    }
    // user added a drink to their check-ins
    else if ([eventType isEqualToString:@"CheckinDrink"]) {
        text = [NSString stringWithFormat:@"%@ had a '%@'", userName, drinkName];
    }
    // user added a drink to their wishlist
    else if ([eventType isEqualToString:@"WishForDrink"]) {
        text = [NSString stringWithFormat:@"%@ added a '%@' to his wishlist", userName, drinkName];
    }

    // set the label text
    cell.textLabel.text = text;

    // set the relative date
    NSString *created = [event valueForKey:@"created_at"];
    NSDate *date = [_dateFormatter dateFromString:created];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ago", [date relativeDate]];

    // TODO: show only if we already have the drink ditails stored locally
//    NSInteger drinkID = [[event valueForKeyPath:@"drink.id"] integerValue];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *event = [_events objectAtIndex:indexPath.row];
    NSInteger drinkID = [[event valueForKey:@"drink_id"] integerValue];
    id drinkDetails = [appDelegate._drinks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id == %d", drinkID]];

    DrinkDetailsViewController *drinkDetailsViewController = [[DrinkDetailsViewController alloc] init];
    drinkDetailsViewController.title = [[drinkDetails valueForKeyPath:@"name"] objectAtIndex:0];
    drinkDetailsViewController.drink = drinkDetails;
    [self.navigationController pushViewController:drinkDetailsViewController animated:YES];
}

@end
