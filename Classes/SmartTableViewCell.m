//
//  Created by Chris Kau on 4/12/12.
//  Copyright 2011 N/A. All rights reserved.
//

#import "SmartTableViewCell.h"


@implementation SmartTableViewCell

+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

+ (id)cellForTableView:(UITableView *)tableView
{
    NSString *identifier = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[self alloc] initWithReuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // initialisation goes here
    }

    return self;
}

@end
