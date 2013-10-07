//
//  Created by Chris Kau on 10/4/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *importVenuesButton;
@property (weak, nonatomic) IBOutlet UIButton *importDrinksButton;
@property (weak, nonatomic) IBOutlet UIButton *importCheckinsButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteAllLocalDataButton;

- (IBAction)importVenues:(id)sender;
- (IBAction)importDrinks:(id)sender;
- (IBAction)importCheckins:(id)sender;
- (IBAction)deleteAllLocalData:(id)sender;

@end
