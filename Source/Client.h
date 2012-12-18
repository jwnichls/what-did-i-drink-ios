//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "AFHTTPClient.h"

@interface Client : AFHTTPClient

+ (Client *)sharedClient;

- (void)allDrinksWithCompletionHandler:(void (^)(id JSON, NSError *error))handler;

- (void)detailsForDrinkWithID:(NSUInteger)drinkID handler:(void (^)(id JSON, NSError *error))handler;

// wishlist
- (void)addDrinkToWishlist:(NSUInteger)drinkID handler:(void (^)(id JSON, NSError *error))handler;


// drinkHistory

// http://whatdididrink.com/users/4 ???


// add new drink to history

// add new drink

// add to favourites

@end

/*
 find some new recipe (OR select drink from built-in list), add to wishlist, drink
 
 sort wishlist based on location (show drinks first that the bar you're in does offer / can make
 
 drink description more wiki style: markup in description, so we can parse out ingredients, garnish, glass, etc.
*/
