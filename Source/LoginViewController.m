//
//  Created by Chris Kau on 1/8/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import "LoginViewController.h"
#import "GAI.h"

@implementation LoginViewController

- (id)init
{
    self = [super initWithNibName:@"LoginView" bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.trackedViewName = @"Login";
}

- (IBAction)login:(id)sender
{
    [self _finish];
}


#pragma mark Private methods

- (void)_finish
{
    NSString *accessToken = self.textField.text;
    if ((accessToken == nil) || (accessToken.length == 0)) return;

    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

#if (!DEBUG)
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    tracker.sessionStart = YES;
    [tracker sendEventWithCategory:@"app_flow"
                        withAction:@"login"
                         withLabel:nil
                         withValue:nil];
#endif

    if ((_delegate) && ([_delegate respondsToSelector:@selector(loginViewControllerDidFinish)])) {
        [_delegate loginViewControllerDidFinish];
    }
}

@end
