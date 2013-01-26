//
//  Created by Chris Kau on 1/25/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "GAITrackedViewController.h"

@protocol NewDrinkViewControllerDelegate;
@class Drink;

@interface NewDrinkViewController : GAITrackedViewController <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) id<NewDrinkViewControllerDelegate> delegate;
@end

@protocol NewDrinkViewControllerDelegate<NSObject>
// Called when the user selects Save or Cancel. If the new drink was saved, drink will be
// a valid drink. Otherwise, drink will be NULL.
// It is up to the delegate to dismiss the view controller.
- (void)newDrinkViewController:(NewDrinkViewController *)viewController didFinishWithDrink:(id)JSON;
@end
