//
//  Created by Chris Kau on 9/24/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "FCModel.h"

@interface Venue : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, copy) NSString *foursq_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *country;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
//t.boolean  "verified"
@property (nonatomic) NSDate *createdTime;
@property (nonatomic) NSDate *modifiedTime;

@end
