//
//  Created by Chris Kau on 1/8/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "GAITrackedViewController.h"

@protocol LoginViewControllerDelegate;

@interface LoginViewController : GAITrackedViewController

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UITextField *textField;

- (IBAction)login:(id)sender;

@end


@protocol LoginViewControllerDelegate<NSObject>
 @optional
- (void)loginViewControllerDidFinish;
- (void)loginViewControllerDidCancel;
@end
