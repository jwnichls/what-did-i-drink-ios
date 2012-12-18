//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "DrinksViewController.h"
#import "SecondViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    UIViewController *viewController1 = [[DrinksViewController alloc] init];
    UIViewController *viewController2 = [[SecondViewController alloc] init];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.title = NSLocalizedString(@"Drinks", @"");
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
