//
//  Created by Chris Kau on 8/1/13.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "WishlistViewController.h"
#import "AppDelegate.h"
#import "Client.h"

@implementation WishlistViewController {
    __weak AppDelegate *appDelegate;

    __strong NSMutableArray *_wishlist;
    __strong UITableView *_tableView;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Wishlist", @"Wishlist");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        CGRect frame = CGRectMake(0.0, 0.0, 320.0, 456.0);
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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

    self.trackedViewName = @"Wishlist";

    // asynchroneouslyload all wishlist entries from server
    [[Client sharedClient] wishlistWithCompletionHandler:^(id JSON, NSError *error) {
        _wishlist = [JSON mutableCopy];
        [_tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // asynchroneously load all wishlist entries from server
    [[Client sharedClient] wishlistWithCompletionHandler:^(id JSON, NSError *error) {
        _wishlist = [JSON mutableCopy];
        [_tableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _wishlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier"];
    NSDictionary *checkin = [_wishlist objectAtIndex:indexPath.row];
    NSNumber *drinkID = [checkin objectForKey:@"drink_id"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", drinkID.integerValue];
    NSDictionary *dict = [[appDelegate._drinks filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *checkin = [_wishlist objectAtIndex:indexPath.row];
    NSNumber *drinkID = [checkin objectForKey:@"drink_id"];

    [[Client sharedClient] removeDrinkFromWishlist:drinkID.integerValue completion:^(id JSON, NSError *error) {
        [_wishlist removeObjectAtIndex:indexPath.row];

        NSArray *indexPaths = @[ indexPath ];
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}


#pragma mark Private methods

- (void)_edit
{
    // TODO: change 'Edit' button to 'Done'

    [_tableView setEditing:YES animated:YES];
}

@end
