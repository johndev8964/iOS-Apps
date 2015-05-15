//
//  TransactionsViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/14/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) IBOutlet UILabel *pointsLabel;
@property(nonatomic, retain) IBOutlet UILabel *moneyLabel;
@property(nonatomic, retain) IBOutlet UIView  *descView;
@property(nonatomic, retain) IBOutlet UIButton *menuBtn;
@property(nonatomic, retain) IBOutlet UIView  *menuView;


- (void) showPointsMoney:(NSString *) points money:(NSString *) money;
- (IBAction) goAddCard:(id)sender;
- (IBAction) goAccountInfo:(id)sender;
- (IBAction) goAbout:(id)sender;

@end
