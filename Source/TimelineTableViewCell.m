//
//  Created by Chris Kau on 2/12/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "TimelineTableViewCell.h"

@implementation TimelineTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(310.0, 8.0, 20.0, 18.0)];
        [self.contentView addSubview:_dateLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    self.textLabel.frame = CGRectMake(10.0, 4.0, 270.0, 52.0);
    _dateLabel.frame = CGRectMake(310.0, 8.0, 20.0, 18.0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
