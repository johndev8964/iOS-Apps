//
//  AddCardViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "AddCardViewController.h"
#import "AboutViewController.h"
#import "AccountInfoViewController.h"
#import "UIColor+HexString.h"
#import "Global.h"
#import "QrcodeScanViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddCardViewController ()

@end

@implementation AddCardViewController

@synthesize menuBtn;
@synthesize qrScanBtn;
@synthesize menuView;
@synthesize aboutBtn;
@synthesize accountInfoBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuBtn.layer.cornerRadius = 8;
    menuBtn.clipsToBounds = YES;
    menuBtn.layer.borderWidth = 1;
    menuBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    qrScanBtn.layer.cornerRadius = 15;
    qrScanBtn.clipsToBounds = YES;
    qrScanBtn.layer.borderWidth = 1;
    qrScanBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    [menuView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goMenu:(id)sender {
    if (menuView.hidden) {
        [menuView setHidden:NO];
        menuView.layer.masksToBounds = NO;
        menuView.layer.cornerRadius = 8; // if you like rounded corners
        menuView.layer.shadowOffset = CGSizeMake(-8, 8);
        menuView.layer.shadowRadius = 1;
        menuView.layer.shadowOpacity = 0.5;
    }
    else {
        [menuView setHidden:YES];
    }
}

- (IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) qrCodeScan:(id)sender {
    //[SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QrcodeScanViewController *qrCodeScanViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"QRCodeScanView"];
    [self.navigationController pushViewController:qrCodeScanViewCtrl animated:NO];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [ touches anyObject ];
    CGPoint location = [ touch locationInView: self.view ];
    if (!CGRectContainsPoint(menuBtn.frame, location)) {
        [menuView setHidden:YES];
    }
}

- (IBAction) goAbout:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController *aboutViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AboutView"];
    [Global pageFlip:self to:aboutViewCtrl];
}

- (IBAction) goAccountInfo:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AccountInfoViewController *accountInfoViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AccountInfoView"];
    [Global pageFlip:self to:accountInfoViewCtrl];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
