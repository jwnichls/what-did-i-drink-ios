//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "DrinksViewController.h"
#import "Client.h"
#import "DrinkOverviewTableCell.h"
#import "DrinkDetailsViewController.h"


@interface DrinksViewController ()
@property (nonatomic, retain) NSArray *drinks;
@end


@implementation DrinksViewController

// private properties
@synthesize drinks = _drinks;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DrinksViewController" bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Drinks", @"Drinks");
        self.tabBarItem.image = [UIImage imageNamed:@"drinks"];
    }

    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[Client sharedClient] allDrinksWithCompletionHandler:^(id JSON, NSError *error) {
        _drinks = JSON;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        [self.tableView reloadData];
    }];
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id drinkDetails = [_drinks objectAtIndex:indexPath.row];

    DrinkDetailsViewController *drinkDetailsViewController = [[DrinkDetailsViewController alloc] init];
    drinkDetailsViewController.title = [drinkDetails valueForKeyPath:@"drink.name"];
    drinkDetailsViewController.drink = drinkDetails;
    [self.navigationController pushViewController:drinkDetailsViewController animated:YES];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.drinks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrinkOverviewTableCell *cell = [DrinkOverviewTableCell cellForTableView:tableView];

    cell.textLabel.text = [[self.drinks objectAtIndex:indexPath.row] valueForKeyPath:@"drink.name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

@end
