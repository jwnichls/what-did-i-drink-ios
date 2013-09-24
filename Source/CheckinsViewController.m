//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "CheckinsViewController.h"
#import "Checkin.h"
#import "Client.h"
#import "CheckinDetailsViewController.h"

@implementation CheckinsViewController {
    __strong UITableView *_tableView;
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

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier"];
    cell.textLabel.text = @"Checkin";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckinDetailsViewController *viewController = [[CheckinDetailsViewController alloc] init];
// TODO:   viewController.checkin = 
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

@end
