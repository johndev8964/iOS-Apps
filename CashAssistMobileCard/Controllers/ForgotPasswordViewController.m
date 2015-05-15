//
//  ForgotPasswordViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "VerificationConfirmViewController.h"
#import "UIColor+HexString.h"
#import "Constants.h"
#import "Global.h"
#import "APIService.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

@synthesize emailText;
@synthesize submitBtn;
@synthesize errorLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    emailText.layer.borderWidth = 1;
    emailText.layer.borderColor = [[UIColor blackColor] CGColor];
    emailText.layer.cornerRadius = 8;
    emailText.clipsToBounds = YES;
    [emailText setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [emailText setText:[prefs stringForKey:USER_EMAIL]];

    submitBtn.layer.cornerRadius = 15;
    submitBtn.clipsToBounds = YES;
    submitBtn.layer.borderWidth = 1;
    submitBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goSubmit:(id)sender {
    if (![self checkValidation]) return;
    
    NSString *udid = [[Global sharedManager] getNewUDID];
    [SVProgressHUD showWithStatus:@"Resending confirmation email..." maskType:SVProgressHUDMaskTypeClear];
    [[APIService sharedManager] forgotPassword:udid email:emailText.text onCompletion:^(NSString *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (error)
        {
            [Global  showAlert:@"Error" description:error.localizedDescription view:self.view];
        }
        else
        {
            if(![udid isEqualToString:[Global httpResponseParser:C_REQUEST_ID result:result]]) return;
            
            int errorCode = [[Global httpResponseParser:C_REQUEST_ERRORCODE result:result] intValue];
            if (errorCode == 0) {
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                VerificationConfirmViewController *verficationConfirmViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"VerificationConfirmView"];
                [Global pageFlip:self to:verficationConfirmViewCtrl];
            }
            else {
                [errorLabel setText:[Global httpResponseParser:C_REQUEST_ERRORTEXT result:result]];
            }
        }
    }];
}

- (IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (Boolean) checkValidation
{
    int vErrorCnt = 0;
    
    if (errorLabel == nil) return false;
    
    [errorLabel setText:@""];
    
    if (emailText == nil) return false;
    
    if (![Global isValidEmail:emailText.text]) {
        vErrorCnt ++;
        [errorLabel setText:@"Invalid Email."];
    }
    
    return (vErrorCnt == 0);
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
