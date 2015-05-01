//
//  CreateAccountViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/8/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "UIColor+HexString.h"
#import "APIService.h"
#import "Global.h"
#import "Constants.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ConfirmEmailViewController.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

@synthesize emailText;
@synthesize passwordText;
@synthesize confirmationText;
@synthesize errorLabel;
@synthesize checkboxImageView;
@synthesize checkboxBtn;
@synthesize registerBtn;
@synthesize descTextbox;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    registerBtn.layer.cornerRadius = 15;
    registerBtn.clipsToBounds = YES;
    registerBtn.layer.borderWidth = 1;
    registerBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    descTextbox.layer.cornerRadius = 8;
    descTextbox.clipsToBounds = YES;
    descTextbox.layer.borderWidth = 1;
    descTextbox.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    emailText.layer.borderWidth = 1;
    emailText.layer.borderColor = [[UIColor blackColor] CGColor];
    emailText.layer.cornerRadius = 8;
    emailText.clipsToBounds = YES;
    [emailText setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
    
    passwordText.layer.borderWidth = 1;
    passwordText.layer.borderColor = [[UIColor blackColor] CGColor];
    passwordText.layer.cornerRadius = 8;
    passwordText.clipsToBounds = YES;
    [passwordText setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
    
    confirmationText.layer.borderWidth = 1;
    confirmationText.layer.borderColor = [[UIColor blackColor] CGColor];
    confirmationText.layer.cornerRadius = 8;
    confirmationText.clipsToBounds = YES;
    [confirmationText setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) checkBoxClick:(id)sender {
    
    NSData *imageViewImageData = UIImagePNGRepresentation(checkboxImageView.image);
    
    UIImage *checkedImage = [UIImage imageNamed:@"checked"];
    NSData *checkedImageData = UIImagePNGRepresentation(checkedImage);
    
    UIImage *uncheckedImage = [UIImage imageNamed:@"unchecked"];
    
    if (![imageViewImageData isEqualToData:checkedImageData]) {
        [checkboxImageView setImage:checkedImage];
        passwordText.secureTextEntry = NO;
        confirmationText.secureTextEntry = NO;
        
    }
    else {
        [checkboxImageView setImage:uncheckedImage];
        passwordText.secureTextEntry = YES;
        confirmationText.secureTextEntry = YES;
    }
}

- (IBAction) goRegister:(id)sender {
    if (![self checkValidation]) return;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:emailText.text forKey:USER_EMAIL];
    [prefs setObject:passwordText.text forKey:USER_PASSWORD];
    
    NSString *udid = [[Global sharedManager] getNewUDID];
    [SVProgressHUD showWithStatus:@"Creating new account..." maskType:SVProgressHUDMaskTypeClear];
    [[APIService sharedManager] createNewAccount:udid email:emailText.text password:passwordText.text onCompletion:^(NSString *result, NSError *error) {
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
                
                if ([userId isEqualToString:@""]) {
                    [errorLabel setText:@"Wrong UserID."];
                }
                else {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ConfirmEmailViewController *confirmEmailViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"ConfirmEmailView"];
                    [Global pageFlip:self to:confirmEmailViewCtrl];
                }
            }
            
            else {
                [errorLabel setText:[Global httpResponseParser:C_REQUEST_ERRORTEXT result:result]];
            }
        }
    }];
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
    
    if (confirmationText == nil) return false;
    
    if (![Global isValidPassword:confirmationText.text]) {
        vErrorCnt ++;
        [errorLabel setText:@"Field is required."];
    }
    else {
        if (![passwordText.text isEqualToString:confirmationText.text]) {
            vErrorCnt ++;
            [errorLabel setText:@"The password and confirmation password don't match."];
        }
    }
    
    return (vErrorCnt == 0);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [emailText resignFirstResponder];
    [passwordText resignFirstResponder];
    [confirmationText resignFirstResponder];
}
@end
