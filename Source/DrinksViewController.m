//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "DrinksViewController.h"
#import "Client.h"
#import "DrinkOverviewTableCell.h"
#import "DrinkDetailsViewController.h"


@implementation DrinksViewController {
    __strong NSArray *_drinks;
    __strong NSMutableArray *_filteredDrinks;
    
    BOOL _isFiltered;

    __strong UITableView *_tableView;
    __strong UISearchBar *_searchBar;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Drinks", @"Drinks");
        self.tabBarItem.image = [UIImage imageNamed:@"drinks"];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 548.0)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
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

    // add search bar
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    view.backgroundColor = [UIColor blueColor];
    _tableView.tableHeaderView = view;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    [view addSubview:_searchBar];

    [[Client sharedClient] allDrinksWithCompletionHandler:^(id JSON, NSError *error) {
        _drinks = JSON;
        [_tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_searchBar resignFirstResponder];

    if (!_isFiltered) {
        _tableView.contentOffset = CGPointMake(0.0, 44.0);
    }
}


#pragma mark UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text
{
    if (text.length == 0) {
        _isFiltered = NO;
    }
    else {
        _isFiltered = YES;
        _filteredDrinks = [[NSMutableArray alloc] init];
        
        for (id drinkDetails in _drinks) {
            NSString *name = [drinkDetails valueForKeyPath:@"drink.name"];
            NSRange nameRange = [name rangeOfString:text options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [_filteredDrinks addObject:drinkDetails];
            }
        }
    }

    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_searchBar resignFirstResponder];

    id drinkDetails = [_drinks objectAtIndex:indexPath.row];

    DrinkDetailsViewController *drinkDetailsViewController = [[DrinkDetailsViewController alloc] init];
    drinkDetailsViewController.title = [drinkDetails valueForKeyPath:@"drink.name"];
    drinkDetailsViewController.drink = drinkDetails;
    [self.navigationController pushViewController:drinkDetailsViewController animated:YES];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;

    if (_isFiltered) {
        numberOfRows = _filteredDrinks.count;
    }
    else {
        numberOfRows = _drinks.count;
    }

    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrinkOverviewTableCell *cell = [DrinkOverviewTableCell cellForTableView:tableView];

    id drinkDetails = nil;
    if (_isFiltered) {
        drinkDetails = [_filteredDrinks objectAtIndex:indexPath.row];
    }
    else {
        drinkDetails = [_drinks objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = [drinkDetails valueForKeyPath:@"drink.name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

@end
