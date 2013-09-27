//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "CheckinsViewController.h"
#import "Checkin.h"
#import "CheckinDetailsViewController.h"
#import "Checkin.h"
#import "User.h"

@implementation CheckinsViewController {
    __strong UITableView *_tableView;
    NSArray *_checkins;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Checkins", @"Checkins");
        self.tabBarItem.image = [UIImage imageNamed:@"checkins"];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                               target:self
                                                                                               action:@selector(_addCheckin)];

        // TODO: show a message if there are no check-ins yet
        CGRect frame = CGRectMake(0.0, 0.0, 320.0, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kCellIdentifier"];

        [self _reloadCheckins:nil];

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_reloadCheckins:) name:FCModelInsertNotification object:Checkin.class];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_reloadCheckins:) name:FCModelDeleteNotification object:Checkin.class];
    }

    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:FCModelInsertNotification object:Checkin.class];
    [NSNotificationCenter.defaultCenter removeObserver:self name:FCModelDeleteNotification object:Checkin.class];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Checkins";
}


#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_checkins count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier"];
    cell.textLabel.text = [[_checkins objectAtIndex:indexPath.row] name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//    CheckinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckinCell" forIndexPath:indexPath];
//    [cell configureWithCheckin:_checkins objectAtIndex:indexPAth.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckinDetailsViewController *viewController = [[CheckinDetailsViewController alloc] init];
    viewController.checkin = _checkins[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark AddCheckinViewControllerDelegate methods

- (void)addCheckinViewControllerDidCancel
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addCheckinViewControllerDidFinish
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark Private methods

- (void)_addCheckin
{
    AddCheckinViewController *viewController = [[AddCheckinViewController alloc] init];
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (void)_reloadCheckins:(NSNotification *)notification
{
    User *user = [[User allInstances] firstObject];
    _checkins = [user checkins];
    self.title = [NSString stringWithFormat:@"%@ (%d)", NSLocalizedString(@"Checkins", @"Checkins"), [_checkins count]];
    [_tableView reloadData];
}

@end
