//
//  AddCardViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCardViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIButton    *menuBtn;
@property(nonatomic, retain) IBOutlet UIButton    *qrScanBtn;
@property(nonatomic, retain) IBOutlet UIView      *menuView;
@property(nonatomic, retain) IBOutlet UIButton    *aboutBtn;
@property(nonatomic, retain) IBOutlet UIButton    *accountInfoBtn;

- (IBAction) goMenu:(id)sender;
- (IBAction) qrCodeScan:(id)sender;
- (IBAction) goAccountInfo:(id)sender;
- (IBAction) goAbout:(id)sender;

@end
