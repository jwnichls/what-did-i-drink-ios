//
//  Created by Chris Kau on 6/5/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "VenuesViewController.h"
#import "AppDelegate.h"
#import "Client.h"
#import "VenueDetailsViewController.h"

@implementation VenuesViewController {
    __weak AppDelegate *appDelegate;

    __strong NSMutableArray *_venues;
    __strong UITableView *_tableView;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Venues", @"Venues");
        self.tabBarItem.image = [UIImage imageNamed:@"location"];
        CGRect frame = CGRectMake(0.0, 0.0, 320.0, 456.0);
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = TABLE_VIEW_BACKGROUND_COLOR;
        _tableView.separatorColor = TABLE_VIEW_SEPARATOR_COLOR;
        [self.view addSubview:_tableView];

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kCellIdentifier"];

        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }

    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Venues";

    // asynchroneouslyload all wishlist entries from server
    [[Client sharedClient] allVenuesWithCompletionHandler:^(id JSON, NSError *error) {
        _venues = [JSON mutableCopy];
        [_tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // asynchroneously load all wishlist entries from server
    [[Client sharedClient] allVenuesWithCompletionHandler:^(id JSON, NSError *error) {
        _venues = [JSON mutableCopy];
        [_tableView reloadData];
    }];
}



#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id venue = [_venues objectAtIndex:indexPath.row];

    VenueDetailsViewController *drinkDetailsViewController = [[VenueDetailsViewController alloc] init];
    drinkDetailsViewController.title = [venue valueForKeyPath:@"name"];
    drinkDetailsViewController.venue = venue;
    [self.navigationController pushViewController:drinkDetailsViewController animated:YES];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier"];
    NSDictionary *venue = [_venues objectAtIndex:indexPath.row];
    cell.textLabel.textColor = TABLE_VIEW_CELL_TEXT_COLOR;
    cell.textLabel.font = TABLE_VIEW_CELL_TEXT_FONT;
    cell.textLabel.text = [venue objectForKey:@"name"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron.png"]];

    return cell;
}

@end
