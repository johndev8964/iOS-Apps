//
//  TransactionsTableViewCell.h
//  CashAssistMobileCard
//
//  Created by User on 4/14/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionsTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *transactionDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsLabel;
@property (nonatomic, retain) IBOutlet UILabel *moneyLabel;
@property (nonatomic, retain) IBOutlet UILabel *shopNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *shopNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *billLabel;

- (void) showCell:(Transaction *) transaction;

@end
