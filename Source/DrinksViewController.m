//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "DrinksViewController.h"
#import "AppDelegate.h"
#import "Client.h"
#import "Drink.h"
#import "DrinkOverviewTableCell.h"
#import "DrinkDetailsViewController.h"


@implementation DrinksViewController {
//    __strong NSMutableArray *_drinks;
    __weak AppDelegate *appDelegate;
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
        CGRect frame = CGRectMake(0.0, 0.0, 320.0, 456.0);
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];

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

    self.trackedViewName = @"Drinks";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(_addDrink)];

    // add search bar
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    view.backgroundColor = [UIColor blueColor];
    _tableView.tableHeaderView = view;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    [view addSubview:_searchBar];

    // load all drinks asynchroneously from server
    [[Client sharedClient] allDrinksWithCompletionHandler:^(id JSON, NSError *error) {
        appDelegate._drinks = [JSON mutableCopy];
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

- (void)loadData
{
    // load all drinks asynchroneously from server
    [[Client sharedClient] allDrinksWithCompletionHandler:^(id JSON, NSError *error) {
        appDelegate._drinks = [JSON mutableCopy];
        [_tableView reloadData];
    }];
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
        
        for (id drinkDetails in appDelegate._drinks) {
            NSString *name = [drinkDetails valueForKeyPath:@"name"];
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

    id drinkDetails = [appDelegate._drinks objectAtIndex:indexPath.row];

    DrinkDetailsViewController *drinkDetailsViewController = [[DrinkDetailsViewController alloc] init];
    drinkDetailsViewController.title = [drinkDetails valueForKeyPath:@"name"];
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
        numberOfRows = appDelegate._drinks.count;
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
        drinkDetails = [appDelegate._drinks objectAtIndex:indexPath.row];
    }

    id name = [drinkDetails valueForKeyPath:@"name"];
    if ((name == nil) || (name == [NSNull null])) name = [NSString stringWithFormat:@"ERROR: id = %@", [drinkDetails valueForKeyPath:@"id"]];
    cell.textLabel.text = name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *drink = [appDelegate._drinks objectAtIndex:indexPath.row];
    NSNumber *drinkID = [drink objectForKey:@"id"];

    [[Client sharedClient] removeDrinkWithID:drinkID.integerValue completion:^(id JSON, NSError *error) {
        if (error == nil) {
            [appDelegate._drinks removeObjectAtIndex:indexPath.row];

            NSArray *indexPaths = @[ indexPath ];
            [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            NSLog(@"ERROR: %@", error.localizedDescription);
        }
    }];
}


#pragma mark AddDrinkViewControllerDelegate methods

- (void)newDrinkViewController:(NewDrinkViewController *)viewController didFinishWithDrink:(id)JSON
{
    [self dismissModalViewControllerAnimated:YES];

    if (JSON != nil) {
        [appDelegate._drinks addObject:JSON];
        appDelegate._drinks = [[appDelegate._drinks sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ]] mutableCopy];
        NSUInteger row = [appDelegate._drinks indexOfObject:JSON];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        NSArray *indexPaths = @[ indexPath ];
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark Private methods

- (void)_addDrink
{
    NewDrinkViewController *viewController = [[NewDrinkViewController alloc] init];
    viewController.delegate = self;
    [self presentModalViewController:viewController animated:YES];
}

@end
