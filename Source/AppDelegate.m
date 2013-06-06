//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationLogger.h"
#import "CheckinsViewController.h"
#import "DrinksViewController.h"
#import "VenuesViewController.h"
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

    [self _customizeAppearance];

    // create the tab bar controller
    self.tabBarController = [[UITabBarController alloc] init];

    // venues
    UIViewController *viewController = [[VenuesViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    // drinks
    _drinksViewController = [[DrinksViewController alloc] init];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:_drinksViewController];

    // checkins
//    UIViewController *viewController2 = [[CheckinsViewController alloc] init];
//    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];

    // wishlist
    UIViewController *viewController3 = [[WishlistViewController alloc] init];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];


    self.tabBarController.title = NSLocalizedString(@"Drinks", @"");
    self.tabBarController.viewControllers = @[ navigationController, navigationController1, navigationController3 ];


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];


    // setup Crashlytics
    [Crashlytics startWithAPIKey:@"d428b1fbc4aadc4e5f99cce2c43724eb9e62055e"];

    // shof the login view if there is no access token stored locally
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    if (accessToken == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.delegate = self;
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
    }

    return YES;
}


#pragma mark LoginViewControllerDelegate methods

- (void)loginViewControllerDidFinish
{
    [_drinksViewController loadData];

    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
}


#pragma mark Private methods

- (void)_customizeAppearance
{
    // customize the appearance of the navigation bar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *titleTextAttributes = @{
                                          UITextAttributeFont : [UIFont fontWithName:@"Helvetica Neue" size:22.0f],
                                          UITextAttributeTextColor : [UIColor colorWithRed:0.988 green:0.988 blue:0.988 alpha:1.0],
                                          UITextAttributeTextShadowColor : [UIColor colorWithRed:0.988 green:0.988 blue:0.988 alpha:1.0],
                                          UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)]
                                         };
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];


    // customize the appearance of the tool bar
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar.png"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    //TODO: [[UITabBar appearance] setSelectionIndicatorImage:nil];
}

@end
