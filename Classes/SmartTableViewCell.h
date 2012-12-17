//
//  Created by Chris Kau on 4/12/12.
//  Copyright 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SmartTableViewCell : UITableViewCell

+ (NSString *)cellIdentifier;
+ (id)cellForTableView:(UITableView *)tableView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
