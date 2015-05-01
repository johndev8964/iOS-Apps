//
//  SigininViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/8/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigininViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *emailText;
@property (nonatomic, retain) IBOutlet UITextField *passwordText;
@property (nonatomic, retain) IBOutlet UIImageView *checkboxImageView;
@property (nonatomic, retain) IBOutlet UIButton    *checkboxBtn;
@property (nonatomic, retain) IBOutlet UITextView  *btnTextbox;
@property (nonatomic, retain) IBOutlet UILabel     *errorLabel;
@property (nonatomic, retain) IBOutlet UIButton    *signinBtn;
@property (nonatomic, retain) IBOutlet UIButton    *createAccountBtn;
@property (nonatomic, retain) IBOutlet UIButton    *forgotPasswordBtn;
@property (nonatomic, retain) IBOutlet UIButton    *verificationBtn;

- (IBAction) checkboxClick:(id)sender;
- (IBAction) goBtn:(id)sender;

@end
