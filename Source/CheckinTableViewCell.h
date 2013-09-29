//
//  Created by Chris Kau on 9/28/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checkin.h"

@interface CheckinTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;

- (void)configureWithCheckin:(Checkin *)checkin;

@end
