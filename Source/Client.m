//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "Client.h"
#import "AFNetworking.h"

NSString *const kBaseURLString = @"http://whatdididrink.com";

@interface Client () {
    void(^_onFetchDrinksBlock)(id JSON, NSError *error);
}

@end


@implementation Client

+ (Client *)sharedClient
{
    static Client *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];

    return self;
}

- (void)allDrinksWithCompletionHandler:(void (^)(id JSON, NSError *error))handler
{
    _onFetchDrinksBlock = [handler copy];

    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"/drinks" parameters:nil];
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (_onFetchDrinksBlock) {
                                          _onFetchDrinksBlock(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      _onFetchDrinksBlock(nil, error);
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)detailsForDrinkWithID:(NSUInteger)drinkID handler:(void (^)(id JSON, NSError *error))handler
{
    _onFetchDrinksBlock = [handler copy];
    
    NSString *path = [NSString stringWithFormat:@"/drinks/%d", drinkID];
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                      path:path
                                                parameters:nil];
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (_onFetchDrinksBlock) {
                                          _onFetchDrinksBlock(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      _onFetchDrinksBlock(nil, error);
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)addDrinkToWishlist:(NSUInteger)drinkID handler:(void (^)(id JSON, NSError *error))handler
{
    NSDictionary *parameters = @{ @"drink_id" : [NSNumber numberWithInteger:drinkID] };
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"/users/4/wishfor" parameters:parameters];
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      NSLog(@"%@", responseObject);
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      NSLog(@"ERROR: %@", error.localizedDescription);
                                  }];

    [self.operationQueue addOperation:operation];
}

/*
 POST to /users/4/checkin with drink_id set to e.g. 7 (the id of the drink)
 */
- (void)checkin:(NSUInteger)drinkID handler:(void (^)(id JSON, NSError *error))handler
{
}

@end
