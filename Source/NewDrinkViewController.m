//
//  Created by Chris Kau on 1/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "NewDrinkViewController.h"
#import "GAI.h"
#import "Client.h"
#import "Drink.h"

@implementation NewDrinkViewController {
    UITextField *_textField;
    UITextView *_textView;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Add Drink";

    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.title = NSLocalizedString(@"New Drink", @"");

    item.leftBarButtonItem = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                              target:self
                              action:@selector(_cancel)];

    item.rightBarButtonItem = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                               target:self
                               action:@selector(_done)];
//    item.rightBarButtonItem.enabled = NO;

    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0f)];
    navigationBar.items = @[ item ];
    [self.view addSubview:navigationBar];

    // drink title
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 50.0, 280.0, 30.0)];
    _textField.delegate = self;
    _textField.placeholder = NSLocalizedString(@"Name", @"");
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.returnKeyType = UIReturnKeyNext;
    [_textField becomeFirstResponder];
    [self.view addSubview:_textField];

    // drink recipe
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 88.0, 280.0, 440.0)];
    _textView.delegate = self;
//    _textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textView];
}


#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textView becomeFirstResponder];

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

- (void)_cancel
{
    if ((_delegate) && ([_delegate respondsToSelector:@selector(newDrinkViewController:didFinishWithDrink:)])) {
        [_delegate newDrinkViewController:self didFinishWithDrink:nil];
    }
}

- (void)_done
{
    Drink *drink = [[Drink alloc] init];
    drink.name = _textField.text;
    drink.recipe = _textView.text;
//    drink.created_at = @""; // current UTC time in ISO 8601 combined date & time format

    [[Client sharedClient] addDrink:drink completion:^(id JSON, NSError *error) {
        if (error == nil) {
#if (!DEBUG)
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            tracker.sessionStart = YES;
            [tracker sendEventWithCategory:@"app_flow"
                                withAction:@"add drink"
                                 withLabel:nil
                                 withValue:nil];
#endif

            if ((_delegate) && ([_delegate respondsToSelector:@selector(newDrinkViewController:didFinishWithDrink:)])) {
                [_delegate newDrinkViewController:self didFinishWithDrink:JSON];
            }
        }
        else {
            NSLog(@"ERROR: %@", error.localizedDescription);

            if ((_delegate) && ([_delegate respondsToSelector:@selector(newDrinkViewController:didFinishWithDrink:)])) {
                [_delegate newDrinkViewController:self didFinishWithDrink:nil];
            }
        }
    }];
}

@end
