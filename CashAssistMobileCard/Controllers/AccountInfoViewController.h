//
//  AccountInfoViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic, retain) IBOutlet UIButton    *menuBtn;
@property(nonatomic, retain) IBOutlet UIButton    *signOutBtn;
@property(nonatomic, retain) IBOutlet UIView      *menuView;
@property(nonatomic, retain) IBOutlet UIButton    *addCardBtn;
@property(nonatomic, retain) IBOutlet UIButton    *aboutBtn;
@property(nonatomic, retain) UIAlertView *signoutConfirmAlertView;

- (IBAction) goMenu:(id)sender;
- (IBAction) goSignOut:(id)sender;
- (IBAction) goAddCard:(id)sender;
- (IBAction) goAbout:(id)sender;

@end
