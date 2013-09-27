//
//  Created by Chris Kau on 9/26/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "FCModel.h"

@interface Drink : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic) NSDate *createdTime;
@property (nonatomic) NSDate *modifiedTime;

@end
