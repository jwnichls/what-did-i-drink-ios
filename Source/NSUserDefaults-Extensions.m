//
//  Created by Chris Kau on 1/19/14.
//  Copyright (c) 2014 N/A. All rights reserved.
//

#import "NSUserDefaults-Extensions.h"

static NSString * const kLastCheckinsUpdate = @"LastCheckinsUpdateKey";
static NSString * const kLastDrinksUpdate = @"LastDrinksUpdateKey";
static NSString * const kLastVenuesUpdate = @"LastVenuesUpdateKey";


@implementation NSUserDefaults (Extensions)

- (NSDate *)dateForLastCheckinsUpdate
{
    return [self objectForKey:kLastCheckinsUpdate];
}

- (NSDate *)dateForLastDrinksUpdate
{
    return [self objectForKey:kLastDrinksUpdate];
}

- (NSDate *)dateForLastVenuesUpdate
{
    return [self objectForKey:kLastVenuesUpdate];
}

@end
