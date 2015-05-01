//
//  ForgotPasswordConfirmViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/10/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordConfirmViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView  *descTextbox;
@property (nonatomic, retain) IBOutlet UIButton    *signinBtn;

- (IBAction) goSignin:(id)sender;

@end
