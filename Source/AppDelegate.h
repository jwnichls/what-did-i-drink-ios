//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic) CLLocationManager *locationManager;
@end
