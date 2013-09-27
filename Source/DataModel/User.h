//
//  Created by Chris Kau on 9/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "FCModel.h"

@interface User : FCModel

// database columns
@property (nonatomic, assign) int64_t id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic) NSDate *createdTime;
@property (nonatomic) NSDate *modifiedTime;

// non-columns
@property (nonatomic) NSArray *checkins;

@end
