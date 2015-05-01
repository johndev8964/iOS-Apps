//
//  ConfirmEmailViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/10/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "ConfirmEmailViewController.h"
#import "Global.h"
#import "Constants.h"
#import "APIService.h"
#import "UIColor+HexString.h"
#import "SigininViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ConfirmEmailViewController ()

@end

@implementation ConfirmEmailViewController

@synthesize descEmailTextbox;
@synthesize descConfirmEmailTextbox;
@synthesize errorLabel;
@synthesize signinBtn;
@synthesize resendConfirmBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    signinBtn.layer.cornerRadius = 15;
    signinBtn.clipsToBounds = YES;
    signinBtn.layer.borderWidth = 1;
    signinBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    resendConfirmBtn.layer.cornerRadius = 15;
    resendConfirmBtn.clipsToBounds = YES;
    resendConfirmBtn.layer.borderWidth = 1;
    resendConfirmBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    descEmailTextbox.layer.cornerRadius = 8;
    descEmailTextbox.clipsToBounds = YES;
    descEmailTextbox.layer.borderWidth = 1;
    descEmailTextbox.layer.borderColor = [[UIColor colorWithHexString:@"#d6e9c6"] CGColor];
    
    descConfirmEmailTextbox.layer.cornerRadius = 8;
    descConfirmEmailTextbox.clipsToBounds = YES;
    descConfirmEmailTextbox.layer.borderWidth = 1;
    descConfirmEmailTextbox.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goSignin:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SigininViewController *signinViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"SigninView"];
    [Global pageFlip:self to:signinViewCtrl];
}

- (IBAction) goVerification:(id)sender {
    NSString *udid = [[Global sharedManager] getNewUDID];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userEmail = [prefs stringForKey:USER_EMAIL];
    
    [SVProgressHUD showWithStatus:@"Resending confirmation email..." maskType:SVProgressHUDMaskTypeClear];
    [[APIService sharedManager] resendConfirmEmail:udid email:userEmail onCompletion:^(NSString *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (error)
        {
            [Global showAlert:@"Error" description:error.localizedDescription view:self.view];
        }
        else
        {
            if(![udid isEqualToString:[Global httpResponseParser:C_REQUEST_ID result:result]]) return;
            
            int errorCode = [[Global httpResponseParser:C_REQUEST_ERRORCODE result:result] intValue];
            if (errorCode == 0) {
                descConfirmEmailTextbox.text = [NSString stringWithFormat:@"If you have not received the confirmation email, try to...\r Last resent: %@",[[Global sharedManager] getDateTimeAsString]];
            }
            else {
                [errorLabel setText:[Global httpResponseParser:C_REQUEST_ERRORTEXT result:result]];
            }
        }
    }];
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
