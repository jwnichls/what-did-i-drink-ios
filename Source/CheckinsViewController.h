//
//  Created by Chris Kau on 4/12/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "AddCheckinViewController.h"

@interface CheckinsViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, AddCheckinViewControllerDelegate>
@property (nonatomic) NSManagedObjectContext *moc;
@end
