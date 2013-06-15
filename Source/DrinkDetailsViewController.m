//
//  Created by Chris Kau on 8/13/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "DrinkDetailsViewController.h"
#import "Checkin.h"
#import "Client.h"
#import "GAI.h"

@implementation DrinkDetailsViewController {
    UITextView *_recipeTextView;
    UIButton *_addToWishlistButton;
    UIButton *_addCheckinButton;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.backgroundColor = TABLE_VIEW_BACKGROUND_COLOR;

        // recipe
        CGFloat height = [[UIScreen mainScreen] applicationFrame].size.height - 4.0f - 40.0f /* navigation bar */;
        CGFloat width = [[UIScreen mainScreen] applicationFrame].size.width;
        _recipeTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 64.0, width, height)];
        _recipeTextView.font = [UIFont systemFontOfSize:18.0];
        _recipeTextView.backgroundColor = TABLE_VIEW_BACKGROUND_COLOR;
        _recipeTextView.textColor = TABLE_VIEW_CELL_TEXT_COLOR;
        [self.view addSubview:_recipeTextView];

        // created_at
        // created_by
        // updated_at
        // urls

        _addToWishlistButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addToWishlistButton.frame = CGRectMake(30.0, self.view.frame.size.height - 130.0, 120.0, 30.0);
        [_addToWishlistButton setTitle:@"Add to Wishlist" forState:UIControlStateNormal];
        [_addToWishlistButton addTarget:self action:@selector(_addToWishlist) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addToWishlistButton];

        _addCheckinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addCheckinButton.frame = CGRectMake(320.0 - 120.0 - 30.0, self.view.frame.size.height - 130.0, 120.0, 30.0);
        [_addCheckinButton setTitle:@"Checkin" forState:UIControlStateNormal];
        [_addCheckinButton addTarget:self action:@selector(_addToCheckins) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addCheckinButton];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Drink Details";

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setDrink:(id)drink
{
    _drink = drink;
    _recipeTextView.text = [drink valueForKey:@"recipe_raw"];
}

- (void)_addToCheckins
{
    Checkin *checkin = [[Checkin alloc] init];
    checkin.drink_id = [[_drink objectForKey:@"id"] integerValue];
    [[Client sharedClient] addCheckin:checkin completion:^(id JSON, NSError *error) {
        NSLog(@"INFO: Checked in %@", [_drink objectForKey:@"name"]);

#if (!DEBUG)
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        tracker.sessionStart = YES;
        [tracker sendEventWithCategory:@"app_flow"
                            withAction:@"add checkin"
                             withLabel:nil
                             withValue:nil];
#endif

    }];
}

- (void)_addToWishlist
{
    NSUInteger drinkID = [[_drink objectForKey:@"id"] integerValue];
    [[Client sharedClient] addDrinkToWishlist:drinkID completion:^(id JSON, NSError *error) {
        NSLog(@"INFO: Added %@ to your wishlist", [_drink objectForKey:@"name"]);

#if (!DEBUG)
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        tracker.sessionStart = YES;
        [tracker sendEventWithCategory:@"app_flow"
                            withAction:@"add to wishlist"
                             withLabel:nil
                             withValue:nil];
#endif

    }];
}

@end
