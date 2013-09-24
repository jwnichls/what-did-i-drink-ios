//
//  Created by Chris Kau on 9/24/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "FCModel.h"
//#import "Drink.h"
//#import "Profile.h"
//#import "Venue.h"

@interface Checkin : FCModel

// database columns:
@property (nonatomic, assign) int64_t id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic, assign) NSUInteger drink_id;
@property (nonatomic, assign) NSUInteger venue_id;
@property (nonatomic) NSDate *createdTime;
@property (nonatomic) NSDate *modifiedTime;

// non-columns:
//@property (nonatomic) Drink *drink;
//@property (nonatomic) Profile *profile;
//@property (nonatomic) Venue *venue;

@end
