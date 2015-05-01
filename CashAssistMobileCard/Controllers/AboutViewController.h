//
//  AboutViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIButton    *menuBtn;
@property(nonatomic, retain) IBOutlet UIButton    *openBtn;
@property(nonatomic, retain) IBOutlet UIView      *menuView;
@property(nonatomic, retain) IBOutlet UIButton    *addCardBtn;
@property(nonatomic, retain) IBOutlet UIButton    *accountInfoBtn;

- (IBAction) goMenu:(id)sender;
- (IBAction) openWebSite:(id)sender;
- (IBAction) goAddCard:(id)sender;
- (IBAction) goAccountInfo:(id)sender;

@end
