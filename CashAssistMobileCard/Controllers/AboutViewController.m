//
//  AboutViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "AboutViewController.h"
#import "AccountInfoViewController.h"
#import "AddCardViewController.h"
#import "UIColor+HexString.h"
#import "Global.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize menuBtn;
@synthesize menuView;
@synthesize openBtn;
@synthesize accountInfoBtn;
@synthesize addCardBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuBtn.layer.cornerRadius = 4;
    menuBtn.clipsToBounds = YES;
    menuBtn.layer.borderWidth = 1;
    menuBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    openBtn.layer.cornerRadius = 15;
    openBtn.clipsToBounds = YES;
    openBtn.layer.borderWidth = 1;
    openBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
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

- (IBAction) openWebSite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://card.cashassist.com"]];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [ touches anyObject ];
    CGPoint location = [ touch locationInView: self.view ];
    if (!CGRectContainsPoint(menuBtn.frame, location)) {
        [menuView setHidden:YES];
    }
}

- (IBAction) goAccountInfo:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AccountInfoViewController *accountInfoViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AccountInfoView"];
    [Global pageFlip:self to:accountInfoViewCtrl];
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
