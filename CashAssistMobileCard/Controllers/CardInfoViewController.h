//
//  CardInfoViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardInfoViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *cardNoLabel;
@property (nonatomic, retain) IBOutlet UILabel *companyNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsLabel;
@property (nonatomic, retain) IBOutlet UILabel *moneyLabel;
@property (nonatomic, retain) IBOutlet UILabel *progressLabel;
@property (nonatomic, retain) IBOutlet UIButton *showTransactionsBtn;
@property (nonatomic, retain) IBOutlet UIButton *menuBtn;
@property (nonatomic, retain) IBOutlet UIView  *menuView;

- (IBAction) showTransactions:(id)sender;
- (IBAction) goAddCard:(id)sender;
- (IBAction) goDeleteCard:(id)sender;
- (IBAction) goAccountInfo:(id)sender;
- (IBAction) goAbout:(id)sender;
- (IBAction) goMenu:(id)sender;

- (void) showDetails:(NSString *) cardNo companyName:(NSString *) companyName;


@end
