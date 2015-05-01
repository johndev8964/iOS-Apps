//
//  CardsTableViewCell.h
//  CashAssistMobileCard
//
//  Created by User on 4/14/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardsTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *logoImageView;
@property (nonatomic, retain) IBOutlet UILabel     *cardNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel     *companyLabel;

- (void) showCardRecord:(NSString *) number company:(NSString *) company;

@end
