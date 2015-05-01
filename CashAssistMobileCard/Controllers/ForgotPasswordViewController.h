//
//  ForgotPasswordViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *emailText;
@property (nonatomic, retain) IBOutlet UILabel     *errorLabel;
@property (nonatomic, retain) IBOutlet UIButton    *submitBtn;

- (IBAction) goSubmit:(id)sender;

@end
