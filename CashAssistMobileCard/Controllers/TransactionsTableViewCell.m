//
//  TransactionsTableViewCell.m
//  CashAssistMobileCard
//
//  Created by User on 4/14/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "TransactionsTableViewCell.h"

@implementation TransactionsTableViewCell

@synthesize transactionDateLabel, pointsLabel, moneyLabel, shopNameLabel, shopNumberLabel, billLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) showCell:(Transaction *) transaction {
    [transactionDateLabel setText:transaction.c1_AlutaDatumZeit];
    
    if (transaction.c7_Points > 0) {
        [pointsLabel setText:[NSString stringWithFormat:@"Points: +%d", transaction.c7_Points]];
    }
    else {
        [pointsLabel setText:[NSString stringWithFormat:@"Points:%d", transaction.c7_Points]];
    }
    
    if (transaction.c5_SollOrHaben > 0) {
        [moneyLabel setText:[NSString stringWithFormat:@"Money: +%ld", transaction.c5_SollOrHaben]];
    }
    else {
        [moneyLabel setText:[NSString stringWithFormat:@"Money: %ld", transaction.c5_SollOrHaben]];
    }
    
    [shopNumberLabel setText:[NSString stringWithFormat:@"Shop: %@", transaction.c3_Number]];
    [shopNameLabel setText:transaction.c4_Bezeichnung];
    [billLabel setText:[NSString stringWithFormat:@"Bill: %@", transaction.c2_BelegNr]];
}

@end
