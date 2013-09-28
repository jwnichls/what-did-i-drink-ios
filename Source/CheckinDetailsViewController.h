//
//  Created by Chris Kau on 8/13/12.
//  Copyright (c) 2012 N/A. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "Checkin.h"

@interface CheckinDetailsViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UILabel *drinkLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLabel;

@property (nonatomic) Checkin *checkin;

// designated initializer
- (id)init;

@end
