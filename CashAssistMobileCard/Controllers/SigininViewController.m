//
//  SigininViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/8/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "SigininViewController.h"
#import "CreateAccountViewController.h"
#import "ForgotPasswordViewController.h"
#import "VerificationEmailViewController.h"
#import "AddCardViewController.h"
#import "UIColor+HexString.h"
#import "Global.h"
#import "Constants.h"
#import "APIService.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SigininViewController ()

@end

@implementation SigininViewController

@synthesize emailText;
@synthesize passwordText;
@synthesize checkboxImageView;
@synthesize checkboxBtn;
@synthesize errorLabel;
@synthesize signinBtn;
@synthesize btnTextbox;
@synthesize createAccountBtn;
@synthesize forgotPasswordBtn;
@synthesize verificationBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    signinBtn.layer.cornerRadius = 15;
    signinBtn.clipsToBounds = YES;
    signinBtn.layer.borderWidth = 1;
    signinBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    btnTextbox.layer.cornerRadius = 8;
    btnTextbox.clipsToBounds = YES;
    btnTextbox.layer.borderWidth = 1;
    btnTextbox.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    emailText.layer.borderWidth = 1;
    emailText.layer.borderColor = [[UIColor blackColor] CGColor];
    emailText.layer.cornerRadius = 8;
    emailText.clipsToBounds = YES;
    [emailText setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [emailText setText:[prefs stringForKey:USER_EMAIL]];
    
    passwordText.layer.borderWidth = 1;
    passwordText.layer.borderColor = [[UIColor blackColor] CGColor];
    passwordText.layer.cornerRadius = 8;
    passwordText.clipsToBounds = YES;
    [passwordText setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) checkboxClick:(id)sender {
    NSData *imageViewImageData = UIImagePNGRepresentation(checkboxImageView.image);
    
    UIImage *checkedImage = [UIImage imageNamed:@"checked"];
    NSData *checkedImageData = UIImagePNGRepresentation(checkedImage);
    
    UIImage *uncheckedImage = [UIImage imageNamed:@"unchecked"];
    
    if (![imageViewImageData isEqualToData:checkedImageData]) {
        [checkboxImageView setImage:checkedImage];
        passwordText.secureTextEntry = NO;
    }
    else {
        [checkboxImageView setImage:uncheckedImage];
        passwordText.secureTextEntry = YES;
    }
}

- (IBAction) goBtn:(id)sender {
    if (sender == signinBtn) {
        if (![self checkValidation]) return;
        
        NSString *udid = [[Global sharedManager] getNewUDID];
        [SVProgressHUD showWithStatus:@"Checking user..." maskType:SVProgressHUDMaskTypeClear];
        [[APIService sharedManager] signIn:udid email:emailText.text password:passwordText.text onCompletion:^(NSString *result, NSError *error) {
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
                    NSString *userId = [Global httpResponseParser:@"1" result:result];
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:userId forKey:USER_ID];
                    
//                    if ([userId isEqualToString:@""]) {
//                        [errorLabel setText:@"Wrong UserID."];
//                    }
//                    else {
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        AddCardViewController *addCardViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddCardView"];
                        [Global pageFlip:self to:addCardViewCtrl];
//                    }
                }
                
                else {
                    [errorLabel setText:[Global httpResponseParser:C_REQUEST_ERRORTEXT result:result]];
                }
            }
        }];

        
    }
    if (sender == createAccountBtn) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CreateAccountViewController *createViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"CreateAccountView"];
        [Global pageFlip:self to:createViewCtrl];
    }
    if (sender == forgotPasswordBtn) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ForgotPasswordViewController *forgotPasswordViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"ForgotPasswordView"];
        [Global pageFlip:self to:forgotPasswordViewCtrl];
    }
    if (sender == verificationBtn) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerificationEmailViewController *verificationEmailViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"VerificationEmailView"];
        [Global pageFlip:self to:verificationEmailViewCtrl];
    }
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
    
    if (passwordText == nil) return false;
    
    if (![Global isValidPassword:passwordText.text]) {
        vErrorCnt ++;
        [errorLabel setText:@"Invalid Password."];
    }
    
    return (vErrorCnt == 0);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [emailText resignFirstResponder];
    [passwordText resignFirstResponder];
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
