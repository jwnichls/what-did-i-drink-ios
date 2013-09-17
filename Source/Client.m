//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "Client.h"
#import "AFNetworking.h"
#import "Checkin.h"
#import "Drink.h"
#import "GTMOAuth2ViewControllerTouch.h"

NSString *const kHTTP_METHOD_DELETE = @"DELETE";
NSString *const kHTTP_METHOD_GET = @"GET";
NSString *const kHTTP_METHOD_POST = @"POST";
NSString *const kHTTP_METHOD_PUT = @"PUT";

NSString *const kClientID = @"00b595070d01d585a22f63f93a75245aa0a213ad49eb77523b7120e11c479206";
NSString *const kClientSecret = @"80f556d63db78f47371e75a8d93a2a9a4e4ae081c9e5c7a96deda72722e4005a";
NSString *const kRedirectURL = @"http://whatdididrink.com/fake/callback";


NSString *const kBaseURLString = @"http://api.whatdididrink.com";
NSString *const kAuthorizeURL = @"http://whatdididrink.com/oauth/authorize";
NSString *const kTokenURL = @"http://whatdididrink.com/oauth/token";

NSString *const kKeychainItemName = @"Drink? OAuth2 Token";


@interface Client () {
    void(^_onFetchDrinksBlock)(id JSON, NSError *error);
}

@end


@implementation Client

@synthesize auth;

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

    auth = [self createNewAuthObject];
    /*if (auth) {
        // get the saved authentication, if any, from the keychain
        [GTMOAuth2ViewControllerTouch authorizeFromKeychainForName:kKeychainItemName
                                                    authentication:auth
                                                             error:nil];
    }*/
    return self;
}

- (GTMOAuth2ViewControllerTouch *)getOAuthLoginControllerWithDelegate:(id <OAuthLoginCompletion>)delegate
{
    NSURL *authURL = [NSURL URLWithString:kAuthorizeURL];
    
    authenticationDelegate = delegate;
    
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                                 authorizationURL:authURL
                                                                 keychainItemName:kKeychainItemName
                                                                         delegate:self
                                                                 finishedSelector:@selector(viewController:finishedWithAuth:error:)];

    return viewController;
}

- (BOOL)isAuthorized
{
    return [auth canAuthorize];
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

    [[self auth] authorizeRequest:request
                completionHandler:^(NSError *error) {

                    if (error != nil) {
                        // TODO: Authorization failed
                    } else {
                        // Authorization succeeded
                        AFHTTPRequestOperation *operation =
                        [self HTTPRequestOperationWithRequest:request
                                                      success:^(AFHTTPRequestOperation *op, id responseObject) {
                                                          if (completion) {
                                                              completion(responseObject, nil);
                                                          }
                                                      }
                                                      failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                                          if (completion) {
                                                              completion(nil, netError);
                                                          }
                                                      }];
                        
                        [self.operationQueue addOperation:operation];
                    }
                }];
}

- (void)removeDrinkWithID:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_DELETE
                                                              path:[NSString stringWithFormat:@"/drinks/%d", drinkID]
                                                        parameters:nil];

    [[self auth] authorizeRequest:request
                completionHandler:^(NSError *error) {
                    
                    if (error != nil) {
                        // TODO: Authorization failed
                    } else {
                        // Authorization succeeded
                        AFHTTPRequestOperation *operation =
                        [self HTTPRequestOperationWithRequest:request
                                                      success:^(AFHTTPRequestOperation *op, id responseObject) {
                                                          if (completion) {
                                                              completion(responseObject, nil);
                                                          }
                                                      }
                                                      failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                                          if (completion) {
                                                              completion(nil, netError);
                                                          }
                                                      }];

                        [self.operationQueue addOperation:operation];
                    }
                }];
}


// checkins
- (void)allCheckinsWithCompletionHandler:(void (^)(id JSON, NSError *error))completion
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_GET
                                                              path:@"/checkins"
                                                        parameters:nil];
    
    [[self auth] authorizeRequest:request
                completionHandler:^(NSError *error) {
                    
                    if (error != nil) {
                        // TODO: Authorization failed
                    } else {
                        // Authorization succeeded
                        AFHTTPRequestOperation *operation =
                        [self HTTPRequestOperationWithRequest:request
                                                      success:^(AFHTTPRequestOperation *op, id responseObject) {
                                                          if (completion) {
                                                              completion(responseObject, nil);
                                                          }
                                                      }
                                                      failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                                          if (completion) {
                                                              completion(nil, netError);
                                                          }
                                                      }];

                        [self.operationQueue addOperation:operation];
                    }
                }];
}

- (void)addCheckin:(Checkin *)checkin completion:(void (^)(id JSON, NSError *error))completion
{
    NSDictionary *parameters = @{ @"drink_id" : [NSNumber numberWithInteger:checkin.drink_id] };

    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_POST
                                                              path:@"/checkins"
                                                        parameters:parameters];

    [[self auth] authorizeRequest:request
                completionHandler:^(NSError *error) {
                    
                    if (error != nil) {
                        // TODO: Authorization failed
                    } else {
                        // Authorization succeeded
                        AFHTTPRequestOperation *operation =
                        [self HTTPRequestOperationWithRequest:request
                                                      success:^(AFHTTPRequestOperation *op, id responseObject) {
                                                          if (completion) {
                                                              completion(responseObject, nil);
                                                          }
                                                      }
                                                      failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                                          if (completion) {
                                                              completion(nil, netError);
                                                          }
                                                      }];

                        [self.operationQueue addOperation:operation];
                    }
                }];
}

- (void)detailsForCheckinWithID:(NSUInteger)checkinID completion:(void (^)(id JSON, NSError *error))completion
{
    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_GET
                                                              path:[NSString stringWithFormat:@"/checkins/%ld", (unsigned long)checkinID]
                                                        parameters:nil];

    [[self auth] authorizeRequest:request
                completionHandler:^(NSError *error) {
                    
                    if (error != nil) {
                        // TODO: Authorization failed
                    } else {
                        // Authorization succeeded
                        AFHTTPRequestOperation *operation =
                        [self HTTPRequestOperationWithRequest:request
                                                      success:^(AFHTTPRequestOperation *op, id responseObject) {
                                                          if (completion) {
                                                              completion(responseObject, nil);
                                                          }
                                                      }
                                                      failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                                          if (completion) {
                                                              completion(nil, netError);
                                                          }
                                                      }];

                        [self.operationQueue addOperation:operation];
                    }
                }];
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
                                  failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                      if (handler) {
                                          handler(nil, netError);
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
    
    [[self auth] authorizeRequest:request
                completionHandler:^(NSError *error) {
                    
                    if (error != nil) {
                        // TODO: Authorization failed
                    } else {
                        // Authorization succeeded
                        AFHTTPRequestOperation *operation =
                        [self HTTPRequestOperationWithRequest:request
                                                      success:^(AFHTTPRequestOperation *op, id responseObject) {
                                                          if (completion) {
                                                              completion(responseObject, nil);
                                                          }
                                                      }
                                                      failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                                          if (completion) {
                                                              completion(nil, netError);
                                                          }
                                                      }];

                        [self.operationQueue addOperation:operation];
                    }
                }];
}

- (void)addDrinkToWishlist:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion
{
    NSDictionary *parameters = @{ @"drink_id" : [NSNumber numberWithInteger:drinkID] };

    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_POST
                                                              path:@"/wishlist"
                                                        parameters:parameters];

    [[self auth] authorizeRequest:request
                completionHandler:^(NSError *error) {
                    
                    if (error != nil) {
                        // TODO: Authorization failed
                    } else {
                        // Authorization succeeded
                        AFHTTPRequestOperation *operation =
                        [self HTTPRequestOperationWithRequest:request
                                                      success:^(AFHTTPRequestOperation *op, id responseObject) {
                                                          if (completion) {
                                                              completion(responseObject, nil);
                                                          }
                                                      }
                                                      failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                                          if (completion) {
                                                              completion(nil, netError);
                                                          }
                                                      }];

                        [self.operationQueue addOperation:operation];
                    }
                }];
}

- (void)removeDrinkFromWishlist:(NSUInteger)drinkID completion:(void (^)(id JSON, NSError *error))completion
{
    NSDictionary *parameters = @{ @"drink_id" : [NSNumber numberWithInteger:drinkID] };

    NSMutableURLRequest *request = [self _mutableRequestWithMethod:kHTTP_METHOD_DELETE
                                                              path:@"/wishlist"
                                                        parameters:parameters];

    [[self auth] authorizeRequest:request
                completionHandler:^(NSError *error) {
                    
                    if (error != nil) {
                        // TODO: Authorization failed
                    } else {
                        // Authorization succeeded
                        AFHTTPRequestOperation *operation =
                        [self HTTPRequestOperationWithRequest:request
                                                      success:^(AFHTTPRequestOperation *op, id responseObject) {
                                                          if (completion) {
                                                              completion(responseObject, nil);
                                                          }
                                                      }
                                                      failure:^(AFHTTPRequestOperation *op, NSError *netError) {
                                                          if (completion) {
                                                              completion(nil, netError);
                                                          }
                                                      }];

                        [self.operationQueue addOperation:operation];
                    }
                }];
}


#pragma mark Private methods

- (NSMutableURLRequest *)_mutableRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    [request addValue:@"application/vnd.drink.v1" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

- (GTMOAuth2Authentication *)createNewAuthObject {
    
    GTMOAuth2Authentication *newAuth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"Drink?"
                                                                                         tokenURL:[NSURL URLWithString:kTokenURL]
                                                                                      redirectURI:kRedirectURL
                                                                                         clientID:kClientID
                                                                                     clientSecret:kClientSecret];
    [newAuth setShouldAuthorizeAllRequests:YES];
    
    return newAuth;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)completedAuth
                 error:(NSError *)error {
    if (error != nil) {
        // Authentication failed
        // TODO: Notify someone
    } else {
        auth = completedAuth;
    }

    if (authenticationDelegate)
        [authenticationDelegate oauthAuthenticationComplete];
}


@end
