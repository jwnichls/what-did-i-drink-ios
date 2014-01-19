//
//  Created by Chris Kau on 1/18/14.
//  Copyright (c) 2014 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

+ (id)sharedManager;

- (void)updateCheckins;
- (void)updateDrinks;
- (void)updateVenues;

// notifications
extern NSString *const CheckinsDidUpdateNotification;
extern NSString *const DrinksDidUpdateNotification;
extern NSString *const VenuesDidUpdateNotification;

@end
