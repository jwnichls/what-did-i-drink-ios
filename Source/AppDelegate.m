//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationLogger.h"
#import "CheckinsViewController.h"
#import "GAI.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

    
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

    // checkins
    CheckinsViewController *checkinsViewController = [[CheckinsViewController alloc] init];
    checkinsViewController.moc = self.managedObjectContext;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:checkinsViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];


    // setup Crashlytics
    [Crashlytics startWithAPIKey:@"d428b1fbc4aadc4e5f99cce2c43724eb9e62055e"];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
    {
        [self saveContext];
    }
    
- (void)applicationWillTerminate:(UIApplication *)application
    {
        [self saveContext];
    }
    
- (void)saveContext
    {
        NSError *error = nil;
        if (_managedObjectContext != nil) {
            [_managedObjectContext processPendingChanges];
            
            if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    
    
#pragma mark - Core Data stack
    
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }

    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self _applicationDocumentsDirectory] URLByAppendingPathComponent:@"drink.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *storePath = [documentsDirectory stringByAppendingPathComponent:@"drink.sqlite"];
    NSDictionary *attributes = @{ NSFileProtectionKey : NSFileProtectionComplete };
    if (![[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:storePath error:&error]) {
        NSLog(@"ERROR: Could not encrypt file %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}


#pragma mark Private methods

- (NSURL *)_applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)_customizeAppearance
{
    // customize the appearance of the navigation bar
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *titleTextAttributes = @{
                                          UITextAttributeFont : [UIFont systemFontOfSize:22.0f],
                                          UITextAttributeTextColor : [UIColor colorWithRed:0.988 green:0.988 blue:0.988 alpha:1.0]
                                         };
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    [[UINavigationBar appearance] setBarTintColor:RGB(84.0f, 192.0f, 255.0f)];

    // customize the appearance of the tool bar
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar.png"]];
//    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithHue:202 saturation:67 brightness:100 alpha:1.0]];
}

@end
