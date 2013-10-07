//
//  Created by Chris Kau on 9/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "User.h"
#import "Checkin.h"

@implementation User

+ (instancetype)currentUser
{
    static dispatch_once_t onceQueue;
    static User *user = nil;
    
    dispatch_once(&onceQueue, ^{ user = [[User allInstances] firstObject]; });

    return user;
}

- (NSArray *)checkins
{
    return [Checkin instancesWhere:@"user_id = ? ORDER BY createdTime DESC", @(_id)];
}

@end
