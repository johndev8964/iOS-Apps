//
//  VerificationConfirmViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/10/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "VerificationConfirmViewController.h"
#import "SigininViewController.h"
#import "UIColor+HexString.h"
#import "Global.h"

@interface VerificationConfirmViewController ()

@end

@implementation VerificationConfirmViewController

@synthesize signinBtn;
@synthesize descTextbox;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    descTextbox.layer.cornerRadius = 8;
    descTextbox.clipsToBounds = YES;
    
    signinBtn.layer.cornerRadius = 15;
    signinBtn.clipsToBounds = YES;
    signinBtn.layer.borderWidth = 1;
    signinBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goSignin:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SigininViewController *siginViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"SigninView"];
    [Global pageFlip:self to:siginViewCtrl];
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
