//
//  QrcodeScanViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/12/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>

@interface QrcodeScanViewController : UIViewController <ZXCaptureDelegate>

@property(nonatomic, retain) IBOutlet UIButton *cancelBtn;

- (IBAction) goCancel:(id)sender;
- (void) goMobileCard;
@end
