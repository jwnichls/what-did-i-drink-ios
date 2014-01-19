//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "AFHTTPClient.h"

@class Drink, Checkin;

@interface Client : AFHTTPClient

@property (nonatomic) NSString *accessToken;

+ (Client *)sharedClient;

// drinks
- (void)allDrinksWithCompletionHandler:(void (^)(id JSON, NSError *error))handler;
- (void)allDrinksSinceDate:(NSDate *)date completion:(void (^)(id JSON, NSError *error))handler;
- (void)detailsForDrinkWithID:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion;
- (void)addDrink:(Drink *)drink completion:(void (^)(id JSON, NSError *error))completion;
- (void)removeDrinkWithID:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion;

// checkins
- (void)allCheckinsWithCompletionHandler:(void (^)(id JSON, NSError *error))handler;
- (void)allCheckinsSinceDate:(NSDate *)date completion:(void (^)(id JSON, NSError *error))handler;
- (void)addCheckin:(Checkin *)checkin completion:(void (^)(id JSON, NSError *error))completion;
- (void)detailsForCheckinWithID:(NSUInteger)checkinID completion:(void (^)(id JSON, NSError *error))completion;

// timeline
- (void)timelineWithCompletionHandler:(void (^)(id JSON, NSError *error))handler;

// wishlist
- (void)wishlistWithCompletionHandler:(void (^)(id JSON, NSError *error))handler;
- (void)addDrinkToWishlist:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion;
- (void)removeDrinkFromWishlist:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion;

// venues
- (void)allVenuesWithCompletionHandler:(void (^)(id JSON, NSError *error))handler;
- (void)allVenuesSinceDate:(NSDate *)date completion:(void (^)(id JSON, NSError *error))handler;

@end
