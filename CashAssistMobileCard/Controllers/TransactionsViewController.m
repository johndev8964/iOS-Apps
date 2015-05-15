//
//  TransactionsViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/14/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionsTableViewCell.h"
#import "AddCardViewController.h"
#import "AccountInfoViewController.h"
#import "AboutViewController.h"
#import "UIColor+HexString.h"
#import "Global.h"

@interface TransactionsViewController ()

@end

@implementation TransactionsViewController

@synthesize pointsLabel;
@synthesize moneyLabel;
@synthesize menuBtn;
@synthesize menuView;
@synthesize descView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    descView.layer.cornerRadius = 8;
    descView.clipsToBounds = YES;
    descView.layer.borderWidth = 1;
    descView.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];

    menuBtn.layer.cornerRadius = 4;
    menuBtn.clipsToBounds = YES;
    menuBtn.layer.borderWidth = 1;
    menuBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    
    [menuView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    if (menuView.hidden) {
        [menuView setHidden:NO];
        menuView.layer.masksToBounds = NO;
        menuView.layer.cornerRadius = 8; // if you like rounded corners
        menuView.layer.shadowOffset = CGSizeMake(-8, 8);
        menuView.layer.shadowRadius = 1;
        menuView.layer.shadowOpacity = 0.5;
        //menuView.layer.backgroundColor = [[UIColor blackColor] CGColor];
    }
    else {
        [menuView setHidden:YES];
    }
}

- (void) showPointsMoney:(NSString *)points money:(NSString *)money {
    [pointsLabel setText:points];
    [moneyLabel setText:money];
}

- (IBAction) goAddCard:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCardViewController *addCardViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddCardView"];
    [Global pageFlip:self to:addCardViewCtrl];
}

- (IBAction) goAccountInfo:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AccountInfoViewController *accountInfoViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AccountInfoView"];
    [Global pageFlip:self to:accountInfoViewCtrl];
}

- (IBAction) goAbout:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController *aboutViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AboutInfoView"];
    [Global pageFlip:self to:aboutViewCtrl];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionsTableViewCell *cell = (TransactionsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TransactionsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat) tableView : (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 80;
}

- (IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
