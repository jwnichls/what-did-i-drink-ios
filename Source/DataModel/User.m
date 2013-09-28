//
//  Created by Chris Kau on 9/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "User.h"
#import "Checkin.h"

@implementation User

- (NSArray *)checkins
{
    return [Checkin instancesWhere:@"user_id = ? ORDER BY createdTime DESC", @(_id)];
}

@end
