//
//  Created by Chris Kau on 8/13/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "CheckinDetailsViewController.h"
#import "Checkin.h"

@implementation CheckinDetailsViewController {
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Checkin Details";
}

- (void)setCheckin:(Checkin *)checkin
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
