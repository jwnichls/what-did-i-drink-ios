//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "CheckinsViewController.h"
#import "AppDelegate.h"
#import "Client.h"

@implementation CheckinsViewController {
    __weak AppDelegate *appDelegate;

    __strong NSMutableArray *_checkins;
    __strong UITableView *_tableView;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Checkins", @"Checkins");
        self.tabBarItem.image = [UIImage imageNamed:@"checkins"];
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

    self.trackedViewName = @"Checkins";

    // load all checkins asynchroneously from server
    [[Client sharedClient] allCheckinsWithCompletionHandler:^(id JSON, NSError *error) {
        _checkins = [JSON mutableCopy];
        [_tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // load all checkins asynchroneously from server
    [[Client sharedClient] allCheckinsWithCompletionHandler:^(id JSON, NSError *error) {
        _checkins = [JSON mutableCopy];
        [_tableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _checkins.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier"];
    NSDictionary *checkin = [_checkins objectAtIndex:indexPath.row];
    NSNumber *drinkID = [checkin objectForKey:@"drink_id"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", drinkID.integerValue];
    NSDictionary *dict = [[appDelegate._drinks filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

@end
