//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//
#import "NewDrinkViewController.h"
#import "GAITrackedViewController.h"

@interface DrinksViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NewDrinkViewControllerDelegate>

- (void)loadData;

@end
