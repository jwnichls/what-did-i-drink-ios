//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "Client.h"
#import "AFHTTPRequestOperationLogger.h"
#import "CheckinsViewController.h"
#import "DrinksViewController.h"
#import "TimelineViewController.h"
#import "WishlistViewController.h"
#import "GAI.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate {
    DrinksViewController *_drinksViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // setup AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];

#if (!DEBUG)
    // setup Google Analytics
    [GAI sharedInstance].dispatchInterval = 20;
    [GAI sharedInstance].debug = YES;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-37810022-1"];
#endif

    self.tabBarController = [[UITabBarController alloc] init];

    // timeline
    UIViewController *viewController = [[TimelineViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    // drinks
    _drinksViewController = [[DrinksViewController alloc] init];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:_drinksViewController];

    // checkins
    UIViewController *viewController2 = [[CheckinsViewController alloc] init];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];

    // wishlist
    UIViewController *viewController3 = [[WishlistViewController alloc] init];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];


    self.tabBarController.title = NSLocalizedString(@"Drinks", @"");
    self.tabBarController.viewControllers = @[ navigationController, navigationController1, navigationController2, navigationController3 ];


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];


    // setup Crashlytics
    [Crashlytics startWithAPIKey:@"d428b1fbc4aadc4e5f99cce2c43724eb9e62055e"];

    // shof the login view if there is no access token stored locally
    Client *client = [Client sharedClient];
    if (![client isAuthorized]) {
        UIViewController *loginViewController = [client getOAuthLoginControllerWithDelegate:self];
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
    }

    return YES;
}


#pragma mark LoginViewControllerDelegate methods

- (void)oauthAuthenticationComplete
{
    [_drinksViewController loadData];

    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
}

@end
