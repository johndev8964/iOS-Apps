//
//  CreateAccountViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/8/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *emailText;
@property (nonatomic, retain) IBOutlet UITextField *passwordText;
@property (nonatomic, retain) IBOutlet UITextField *confirmationText;
@property (nonatomic, retain) IBOutlet UILabel     *errorLabel;
@property (nonatomic, retain) IBOutlet UIButton *registerBtn;
@property (nonatomic, retain) IBOutlet UIImageView *checkboxImageView;
@property (nonatomic, retain) IBOutlet UIButton *checkboxBtn;
@property (nonatomic, retain) IBOutlet UITextView *descTextbox;

- (IBAction) checkBoxClick:(id)sender;
- (IBAction) goRegister:(id)sender;

- (Boolean) checkValidation;

@end
