//
//  ConfirmEmailViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/10/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmEmailViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView *descEmailTextbox;
@property (nonatomic, retain) IBOutlet UIButton   *signinBtn;
@property (nonatomic, retain) IBOutlet UILabel    *errorLabel;
@property (nonatomic, retain) IBOutlet UITextView *descConfirmEmailTextbox;
@property (nonatomic, retain) IBOutlet UIButton   *resendConfirmBtn;

- (IBAction) goSignin:(id)sender;
- (IBAction) goVerification:(id)sender;

@end
