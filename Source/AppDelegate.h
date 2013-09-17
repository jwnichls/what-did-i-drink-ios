//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "Client.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, OAuthLoginCompletion>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) NSMutableArray *_drinks;

@end
