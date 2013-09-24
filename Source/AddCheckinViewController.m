//
//  Created by Chris Kau on 1/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "AddCheckinViewController.h"
#import "GAI.h"
#import "Client.h"
#import "Drink.h"

// TODO:
// scroll up so that the text field the user is entering information into is always at the top

@implementation AddCheckinViewController {
    UITextField *_textField;
    UITextView *_textView;
}

- (id)init
{
    self = [super initWithNibName:@"AddCheckinView" bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Add Checkin";

    // drink name
    self.drinkTextField.delegate = self;
    self.drinkTextField.placeholder = NSLocalizedString(@"Name", @"");
    self.drinkTextField.backgroundColor = [UIColor whiteColor];
    self.drinkTextField.returnKeyType = UIReturnKeyNext;
    [self.drinkTextField becomeFirstResponder];

    // venue name
    self.venueTextField.delegate = self;
    self.venueTextField.returnKeyType = UIReturnKeyDone;
}


#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.drinkTextField becomeFirstResponder];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


#pragma mark UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


#pragma mark Private methods

- (IBAction)cancel:(id)sender
{
    if ((_delegate) && ([_delegate respondsToSelector:@selector(addCheckinViewControllerDidCancel)])) {
        [_delegate addCheckinViewControllerDidCancel];
    }
}

- (IBAction)done:(id)sender
{
    if ((_delegate) && ([_delegate respondsToSelector:@selector(addCheckinViewControllerDidFinish)])) {
        [_delegate addCheckinViewControllerDidFinish];
    }

//    Drink *drink = [[Drink alloc] init];
//    drink.name = _textField.text;
//    drink.recipe = _textView.text;
//    drink.created_at = @""; // current UTC time in ISO 8601 combined date & time format

//    [[Client sharedClient] addDrink:drink completion:^(id JSON, NSError *error) {
//        if (error == nil) {
//#if (!DEBUG)
//            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//            tracker.sessionStart = YES;
//            [tracker sendEventWithCategory:@"app_flow"
//                                withAction:@"add drink"
//                                 withLabel:nil
//                                 withValue:nil];
//#endif
//
//            if ((_delegate) && ([_delegate respondsToSelector:@selector(newDrinkViewController:didFinishWithDrink:)])) {
//                [_delegate newDrinkViewController:self didFinishWithDrink:JSON];
//            }
//        }
//        else {
//            NSLog(@"ERROR: %@", error.localizedDescription);
//
//            if ((_delegate) && ([_delegate respondsToSelector:@selector(newDrinkViewController:didFinishWithDrink:)])) {
//                [_delegate newDrinkViewController:self didFinishWithDrink:nil];
//            }
//        }
//    }];
}

@end
