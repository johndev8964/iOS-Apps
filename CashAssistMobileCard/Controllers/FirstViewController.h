//
//  FirstViewController.h
//  CashAssistMobileCard
//
//  Created by User on 4/8/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton * createBtn;
@property (nonatomic, retain) IBOutlet UIButton * siginBtn;

- (IBAction) goCreateAccount:(id)sender;
- (IBAction) goSigin:(id)sender;

@end
