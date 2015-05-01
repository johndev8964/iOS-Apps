//
//  CAMobileCardViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAMobileCardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *cardsList;
@property (nonatomic, retain) IBOutlet UIView      *paymentView;
@property (nonatomic, retain) IBOutlet UIButton    *cardBtn;
@property (nonatomic, retain) IBOutlet UIButton    *paymentBtn;
@property (nonatomic, retain) IBOutlet UILabel     *cardLabel;
@property (nonatomic, retain) IBOutlet UILabel     *paymentLabel;
@property (nonatomic, retain) IBOutlet UIButton    *menuBtn;
@property (nonatomic, retain) IBOutlet UIView      *menuView;
@property (nonatomic, retain) IBOutlet UILabel     *payCardStatus;
@property (nonatomic, retain) IBOutlet UIButton    *qrScanBtn;
@property (nonatomic, retain) UIAlertView          *selectNumberAlert;

- (IBAction) goMenu:(id)sender;
- (IBAction) showCardsTableView:(id)sender;
- (IBAction) showPayWithCardsView:(id)sender;
- (IBAction) qrCodeScan:(id)sender;
- (IBAction) goAddCard:(id)sender;
- (IBAction) goAbout:(id)sender;
- (IBAction) goAccountInfo:(id)sender;

- (void) showPayCardStatus:(NSString *) status;
- (void) processPayWithCards:(NSString *) result;

@end
