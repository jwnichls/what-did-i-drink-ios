//
//  Created by Chris Kau on 8/13/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "DrinkDetailsViewController.h"
#import "Client.h"

@implementation DrinkDetailsViewController {
    UITextView *_recipeTextView;
    UIButton *_addToWishlistButton;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // recipe
        CGFloat height = [[UIScreen mainScreen] applicationFrame].size.height - 4.0f - 40.0f /* navigation bar */;
        CGFloat width = [[UIScreen mainScreen] applicationFrame].size.width;
        _recipeTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
        _recipeTextView.font = [UIFont systemFontOfSize:18.0];
        [self.view addSubview:_recipeTextView];

        // created_at
        // created_by
        // updated_at
        // urls

//        _addToWishlistButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _addToWishlistButton.frame = CGRectMake(20.0, 20.0, 80.0, 25.0);
//        [_addToWishlistButton setTitle:@"Add to Wishlist" forState:UIControlStateNormal];
//        [_addToWishlistButton addTarget:self action:@selector(addToWishlist) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_addToWishlistButton];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setDrink:(id)drink
{
    _drink = drink;
    _recipeTextView.text = [drink valueForKeyPath:@"drink.recipe"];
}

- (void)checkin
{
}

- (void)addToWishlist
{
    [[Client sharedClient] addDrinkToWishlist:9 handler:^(id JSON, NSError *error) {
    }];
}

@end
