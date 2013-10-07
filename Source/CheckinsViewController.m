//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "CheckinsViewController.h"
#import "Checkin.h"
#import "CheckinDetailsViewController.h"
#import "CheckinTableViewCell.h"
#import "User.h"


@implementation CheckinsViewController {
    __strong UITableView *_tableView;
    UITapGestureRecognizer *_gestureRecognizer;

    NSArray *_checkins;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Checkins", @"Checkins");
        self.tabBarItem.image = [UIImage imageNamed:@"checkins"];

        // create & add a add checkin button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                               target:self
                                                                                               action:@selector(_addCheckin)];

        // create & add a button to reveal the settings
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                        target:self
                                                                                        action:@selector(_showSettings)];


        // TODO: show a message if there are no check-ins yet


        // configure the table view
        CGRect frame = CGRectMake(0.0, 0.0, 320.0, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 82.0f;
        [self.view addSubview:_tableView];

        UINib *cellNib = [UINib nibWithNibName:@"CheckinTableViewCell" bundle:nil];
        [_tableView registerNib:cellNib forCellReuseIdentifier:@"CheckinCellIdentifier"];


        // load all checkins
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
    CheckinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckinCellIdentifier" forIndexPath:indexPath];
    [cell configureWithCheckin:[_checkins objectAtIndex:indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
    [self dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
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
    User *user = [User currentUser];
    _checkins = [user checkins];
    self.title = [NSString stringWithFormat:@"%@ (%d)", NSLocalizedString(@"Checkins", @"Checkins"), [_checkins count]];
    [_tableView reloadData];
}

- (void)_showSettings
{
    _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_hideSettings)];
    [self.view addGestureRecognizer:_gestureRecognizer];

    self.navigationItem.leftBarButtonItem.enabled = NO;

    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.view.x += 300.0f;
    }];
}

- (void)_hideSettings
{
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.view.x = 0.0f;
    }];

    [self.view removeGestureRecognizer:_gestureRecognizer];
    _gestureRecognizer = nil;

    self.navigationItem.leftBarButtonItem.enabled = YES;
}

@end
