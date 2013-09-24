//
//  Created by Chris Kau on 1/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "GAITrackedViewController.h"

@protocol AddCheckinViewControllerDelegate;
@class Drink;

@interface AddCheckinViewController : GAITrackedViewController <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) id<AddCheckinViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *drinkTextField;
@property (weak, nonatomic) IBOutlet UITextField *venueTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol AddCheckinViewControllerDelegate<NSObject>
- (void)addCheckinViewControllerDidCancel;
- (void)addCheckinViewControllerDidFinish;
@end
