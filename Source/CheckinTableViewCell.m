//
//  Created by Chris Kau on 9/28/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "CheckinTableViewCell.h"
#import "Venue.h"

@implementation CheckinTableViewCell {
    Checkin *_checkin;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // initialization code
    }

    return self;
}

- (void)configureWithCheckin:(Checkin *)checkin
{
    _checkin = checkin;

    self.nameLabel.text = checkin.name;
    Venue *venue = [Venue instanceWithPrimaryKey:@(checkin.venue_id)];
    self.venueNameLabel.text = venue.name;
    self.dateLabel.text = [checkin.createdTime relativeDate];

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
