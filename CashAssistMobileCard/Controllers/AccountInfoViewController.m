//
//  AccountInfoViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AddCardViewController.h"
#import "FirstViewController.h"
#import "AboutViewController.h"
#import "Global.h"
#import "UIColor+HexString.h"
#import "Constants.h"

@interface AccountInfoViewController ()

@end

@implementation AccountInfoViewController

@synthesize menuBtn;
@synthesize menuView;
@synthesize signOutBtn;
@synthesize aboutBtn;
@synthesize addCardBtn;
@synthesize signoutConfirmAlertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuBtn.layer.cornerRadius = 4;
    menuBtn.clipsToBounds = YES;
    menuBtn.layer.borderWidth = 1;
    menuBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    signOutBtn.layer.cornerRadius = 15;
    signOutBtn.clipsToBounds = YES;
    signOutBtn.layer.borderWidth = 1;
    signOutBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
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

- (IBAction) goSignOut:(id)sender {
    signoutConfirmAlertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to sign out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [signoutConfirmAlertView show];
}

- (IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self clearDefaultsData];
            [signoutConfirmAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [self goSignin];

            break;
        default:
            break;
    }
}

- (void) goSignin {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FirstViewController *firstViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"FirstView"];
    [Global pageFlip:self to:firstViewCtrl];
}

- (void) clearDefaultsData {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
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

- (IBAction) goAddCard:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCardViewController *addCardViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddCardView"];
    [Global pageFlip:self to:addCardViewCtrl];
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
