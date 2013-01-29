//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "Client.h"
#import "AFNetworking.h"
#import "Checkin.h"
#import "Drink.h"

NSString *const kHTTP_METHOD_DELETE = @"DELETE";
NSString *const kHTTP_METHOD_GET = @"GET";
NSString *const kHTTP_METHOD_POST = @"POST";
NSString *const kHTTP_METHOD_PUT = @"PUT";


NSString *const kBaseURLString = @"http://api.whatdididrink.com";

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

- (void)allDrinksWithCompletionHandler:(void (^)(id JSON, NSError *error))completion
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_GET
                                                              path:@"/drinks"
                                                        parameters:nil];
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)detailsForDrinkWithID:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:@"/drinks/%d", drinkID];
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_GET
                                                              path:path
                                                        parameters:nil];
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)addDrink:(Drink *)drink completion:(void (^)(id JSON, NSError *error))completion;
{
    NSDictionary *parameters = @{ @"name" : drink.name, @"recipe" : drink.recipe };

    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_POST
                                                              path:@"/drinks"
                                                        parameters:parameters];

    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)removeDrinkWithID:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_DELETE
                                                              path:[NSString stringWithFormat:@"/drinks/%d", drinkID]
                                                        parameters:nil];

    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}


// checkins
- (void)allCheckinsWithCompletionHandler:(void (^)(id JSON, NSError *error))completion
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_GET
                                                              path:@"/checkins"
                                                        parameters:nil];
    
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)addCheckin:(Checkin *)checkin completion:(void (^)(id JSON, NSError *error))completion
{
    NSDictionary *parameters = @{ @"drink_id" : [NSNumber numberWithInteger:checkin.drink_id] };

    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_POST
                                                              path:@"/checkins"
                                                        parameters:parameters];

    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)detailsForCheckinWithID:(NSUInteger)checkinID completion:(void (^)(id JSON, NSError *error))completion
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_GET
                                                              path:[NSString stringWithFormat:@"/checkins/%ld", (unsigned long)checkinID]
                                                        parameters:nil];

    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}


// timeline

- (void)timelineWithCompletionHandler:(void (^)(id JSON, NSError *error))handler
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_GET
                                                              path:@"/timeline"
                                                        parameters:nil];

    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (handler) {
                                          handler(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (handler) {
                                          handler(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}


// wishlist

- (void)wishlistWithCompletionHandler:(void (^)(id JSON, NSError *error))completion
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_GET
                                                              path:@"/wishlist"
                                                        parameters:nil];
    
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)addDrinkToWishlist:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion
{
    NSDictionary *parameters = @{ @"drink_id" : [NSNumber numberWithInteger:drinkID] };

    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_POST
                                                              path:@"/wishlist"
                                                        parameters:parameters];

    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}

- (void)removeDrinkFromWishlist:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion
{
    NSDictionary *parameters = @{ @"drink_id" : [NSNumber numberWithInteger:drinkID] };

    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_DELETE
                                                              path:@"/wishlist"
                                                        parameters:parameters];

    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *op, id responseObject) {
                                      if (completion) {
                                          completion(responseObject, nil);
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                      if (completion) {
                                          completion(nil, error);
                                      }
                                  }];

    [self.operationQueue addOperation:operation];
}


#pragma mark Private methods

- (NSMutableURLRequest *)_mutableRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    self.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    if (self.accessToken == nil) return nil;

    NSMutableDictionary *params = [@{ @"access_token" : self.accessToken } mutableCopy];
    [params addEntriesFromDictionary:parameters];

    NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:params];
    [request addValue:@"application/vnd.drink.v1" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return request;
}

@end
