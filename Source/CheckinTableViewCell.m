//
//  Created by Chris Kau on 9/28/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "CheckinTableViewCell.h"

@implementation CheckinTableViewCell {
    Checkin *_checkin;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithCheckin:(Checkin *)checkin
{
    _checkin = checkin;

    self.textLabel.text = checkin.name;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
