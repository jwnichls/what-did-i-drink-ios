//
//  Created by Chris Kau on 9/24/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "Venue.h"

@implementation Venue

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@; %@; %@; %@; %f, %f>", self.name, self.address, self.city, self.postalCode, self.longitude, self.latitude];
}

@end
