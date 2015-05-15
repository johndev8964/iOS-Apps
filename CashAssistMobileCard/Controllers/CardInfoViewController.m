//
//  CardInfoViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "CardInfoViewController.h"
#import "UIColor+HexString.h"
#import "Global.h"
#import "APIService.h"
#import "Constants.h"
#import "Transaction.h"
#import "TransactionsViewController.h"
#import "AddCardViewController.h"
#import "AccountInfoViewController.h"
#import "CAMobileCardViewController.h"
#import "AboutViewController.h"
#import <CocoaSecurity/CocoaSecurity.h>


@interface CardInfoViewController ()

@property (nonatomic, retain) NSString *mCardGUID, *mCardID, *mUserID, *mCompany, *mCardNumber, *mAccessCode, *mCompanyName;
@property (nonatomic) long mActiveRequestTimeout;

@end

@implementation CardInfoViewController

@synthesize menuBtn;
@synthesize showTransactionsBtn;
@synthesize menuView;
@synthesize cardNoLabel;
@synthesize companyNameLabel;
@synthesize pointsLabel;
@synthesize moneyLabel;
@synthesize progressLabel;
@synthesize mCardID, mCardGUID, mCardNumber, mCompany, mUserID, mAccessCode, mActiveRequestTimeout, mCompanyName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuBtn.layer.cornerRadius = 4;
    menuBtn.clipsToBounds = YES;
    menuBtn.layer.borderWidth = 1;
    menuBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    showTransactionsBtn.layer.cornerRadius = 15;
    showTransactionsBtn.clipsToBounds = YES;
    showTransactionsBtn.layer.borderWidth = 1;
    showTransactionsBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    [menuView setHidden:YES];

    progressLabel.layer.cornerRadius = 8;
    progressLabel.clipsToBounds = YES;
    progressLabel.layer.borderWidth = 1;
    progressLabel.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    [cardNoLabel setText:mCardNumber];
    [companyNameLabel setText:mCompanyName];
    
    [self sendRequestPrepareCardBalance];
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [ touches anyObject ];
    CGPoint location = [ touch locationInView: self.view ];
    if (!CGRectContainsPoint(menuBtn.frame, location)) {
        [menuView setHidden:YES];
    }
}

- (void) sendRequestPrepareCardBalance {
    mCompany = @"";
    mAccessCode = @"";
    mUserID = @"";
    mCardID = @"";
    
    for(CardRecord *_card in g_CardsModel.cardsArray) {
        if ([mCardNumber isEqualToString:_card.number]) {
            mUserID = _card.userid;
            mCompany = _card.company;
            mCardID = _card.cardid;
            
            NSData *key = [C_MOBILE_KEY dataUsingEncoding:NSUTF8StringEncoding];
            NSData *vector = [C_MOBILE_VECTOR dataUsingEncoding:NSUTF8StringEncoding];
            CocoaSecurityResult *aes256Decrypt = [CocoaSecurity aesDecryptWithBase64:_card.accesscode key:key iv:vector];
            mAccessCode = aes256Decrypt.utf8String;
        }
    }
    
    NSString *udid = [[Global sharedManager] getNewUDID];
    [[APIService sharedManager] getCardBalancePrepareData:udid clientId:mUserID company:mCompany number:mCardNumber accessCode:mAccessCode onCompletion:^(NSString *result, NSError *error) {
        if (!error) {
            [progressLabel setHidden:YES];
            [self processAnswer:result];
        }
        else {
            [progressLabel setText:error.localizedDescription];
        }
    }];
}

- (void) processAnswer:(NSString *) result {
    int errorCode = [[Global httpResponseParser:C_REQUEST_ERRORCODE result:result] intValue];
    if (errorCode == 0) {
        int requestType = [[Global httpResponseParser:C_REQUEST_TYPE result:result] intValue];
        
        switch (requestType) {
            case RT5_PREPARECARDBALANCE:
                [self processAnswerPrepareCardBalance:result];
                break;
            
            case RT6_GETCARDBALANCE:
                [self processAnswerGetCardBalance:result];
                break;
            
            case RT8_PREPARECARDBALANCEWITHTRANSACTIONS:
                [self processAnswerPrepareCardBalanceWithTransactions:result];
                break;
                
            case RT9_GETCARDBALANCEWITHTRANSACTIONS:
                [self processAnswerGetCardBalanceWithTransactions:result];
                break;
                
            default:
                break;
        }
    }
}

- (void) processAnswerPrepareCardBalance:(NSString *) result {
    mCardGUID = [Global httpResponseParser:@"guid" result:result];
    NSString* vCardID   = [Global httpResponseParser:@"cardid" result:result];
    
    if (![mCardID isEqualToString:vCardID]) {
        for(CardRecord *_card in g_CardsModel.cardsArray) {
            if ([mCardNumber isEqualToString:_card.number]) {
                _card.cardid = vCardID;
                [g_CardsModel updateArray:_card];
            }
        }
    }
    
    if ([mCardGUID isEqualToString:@""]) {
        [progressLabel setText:@"Wrong request answer"];
        return;
    }
    
    mActiveRequestTimeout = 0;
    mActiveRequestTimeout = ([[NSDate date] timeIntervalSince1970] + 10) * 1000;
    
    [self sendRequestDelayGetCardBalance];
}

- (void) sendRequestDelayGetCardBalance {
    [NSThread sleepForTimeInterval:0.25];
    
    NSString *udid = [[Global sharedManager] getNewUDID];
    [[APIService sharedManager] getCardBalanceData:udid guid:mCardGUID onCompletion:^(NSString *result, NSError *error) {
        if (error == nil) {
            [self processAnswer:result];
        }
        else {
            [progressLabel setText:error.localizedDescription];
        }
    }];
}

- (void) processAnswerGetCardBalance:(NSString *) result {
    int vStatus = [[Global httpResponseParser:@"status" result:result] intValue];
    
    switch (vStatus) {
        case 1:
            if (mActiveRequestTimeout < [[NSDate date] timeIntervalSince1970] * 1000) {
                mActiveRequestTimeout = 0;
                [progressLabel setHidden:NO];
                [progressLabel setText:@"Request Timeout."];
            }
            else {
                [self sendRequestDelayGetCardBalance];
            }
            break;
            
        case 2:
            [pointsLabel setText:[Global httpResponseParser:@"points" result:result]];
            [moneyLabel setText:[NSString stringWithFormat:@"%@ %@", [Global httpResponseParser:@"saldo" result:result], [Global httpResponseParser:@"currency" result:result]]];
            
            [progressLabel setHidden:YES];
            mActiveRequestTimeout = 0;
            break;
    }
}

- (void) processAnswerPrepareCardBalanceWithTransactions:(NSString *) result {
    mCardGUID = [Global httpResponseParser:@"guid" result:result];
    
    if ([mCardGUID isEqualToString:@""]) {
        [progressLabel setHidden:NO];
        [progressLabel setText:@"Wrong request answer."];
        return;
    }
    
    mActiveRequestTimeout = 0;
    mActiveRequestTimeout = ([[NSDate date] timeIntervalSince1970] + 10) * 1000;
    [self sendRequestDelayGetCardBalanceWithTransactions];
}

- (void) sendRequestDelayGetCardBalanceWithTransactions {
    [NSThread sleepForTimeInterval:0.25];
    
    NSString *udid = [[Global sharedManager] getNewUDID];
    [[APIService sharedManager] getCardBalanceDataWithTransaction:udid guid:mCardGUID onCompletion:^(NSString *result, NSError *error) {
        if (error == nil) {
            [self processAnswer:result];
        }
        else {
            [progressLabel setText:error.localizedDescription];
        }
    }];
}

- (void) processAnswerGetCardBalanceWithTransactions:(NSString *) result {
    int vStatus = [[Global httpResponseParser:@"status" result:result] intValue];
    
    switch (vStatus) {
        case 1:
            if (mActiveRequestTimeout < [[NSDate date] timeIntervalSince1970] * 1000) {
                mActiveRequestTimeout = 0;
                [progressLabel setText:@"Request Timeout."];
            }
            else {
                [self sendRequestDelayGetCardBalanceWithTransactions];
            }
            break;
            
        case 2:
            [pointsLabel setText:[Global httpResponseParser:@"points" result:result]];
            [moneyLabel setText:[NSString stringWithFormat:@"%@ %@", [Global httpResponseParser:@"saldo" result:result], [Global httpResponseParser:@"currency" result:result]]];
            
            [progressLabel setHidden:YES];
            mActiveRequestTimeout = 0;
            [self goToTransaction:[Global httpResponseParser:@"data" result:result]];
            break;
    }
}

- (void) goToTransaction:(NSString *) data {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];//response object is your response from server as NSData
    int i = 0;
    
    for (NSDictionary *dictionary in json) {
        Transaction *transaction = [[Transaction alloc] init];
        transaction.transactionID = i+1;
        transaction.c1_AlutaDatumZeit = [[Global sharedManager] convertDateFormatToString:[dictionary objectForKey:@"C1"]];
        transaction.c2_BelegNr        = [dictionary objectForKey:@"C2"];
        transaction.c3_Number         = [dictionary objectForKey:@"C3"];
        transaction.c4_Bezeichnung    = [dictionary objectForKey:@"C4"];
        transaction.c5_SollOrHaben    = [[dictionary objectForKey:@"C5"] longLongValue];
        transaction.c6_Saldo          = [[dictionary objectForKey:@"C6"] longLongValue];
        transaction.c7_Points         = [[dictionary objectForKey:@"C7"] intValue];
        transaction.c8_TotalPoints    = [[dictionary objectForKey:@"C8"] intValue];
        i ++;
        [g_Global.transactionsArray addObject:transaction];
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TransactionsViewController *transactionViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"TransactionView"];
    [Global pageFlip:self to:transactionViewCtrl];
    [transactionViewCtrl showPointsMoney:pointsLabel.text money:moneyLabel.text];
}

- (IBAction) showTransactions:(id)sender {
    [progressLabel setHidden:NO];
    
    g_Global = [[Global alloc] init];
    g_Global.transactionsArray = [[NSMutableArray alloc] init];
    
    mActiveRequestTimeout = 0;
    NSString *udid = [[Global sharedManager] getNewUDID];
    [[APIService sharedManager] getCardBalancePrepareDataWithTransaction:udid clientId:mUserID company:mCompany number:mCardNumber accessCode:mAccessCode onCompletion:^(NSString *result, NSError *error) {
        if (error == nil) {
            [progressLabel setHidden:YES];
            [self processAnswer:result];
        }
        else {
            [progressLabel setText:error.localizedDescription];
        }
    }];
}

- (IBAction) goAddCard:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCardViewController *addViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddCardView"];
    [Global pageFlip:self to:addViewCtrl];
}

- (IBAction) goDeleteCard:(id)sender {
    for (int i = 0; i < [g_CardsModel.cardsArray count]; i++) {
        CardRecord *_card = [g_CardsModel.cardsArray objectAtIndex:i];
        if ([mCardNumber isEqualToString:_card.number]) {
            [g_CardsModel.cardsArray removeObject:_card];
            i--;
        }
    }
    
    [g_CardsModel updateDB];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction) goAccountInfo:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AccountInfoViewController *accountInfoCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AccountInfoView"];
    [Global pageFlip:self to:accountInfoCtrl];
}

- (IBAction) goAbout:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController *aboutViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AboutView"];
    [Global pageFlip:self to:aboutViewCtrl];
}

- (void) showDetails:(NSString *)cardNo companyName:(NSString *)companyName {
    mCardNumber = cardNo;
    mCompanyName = companyName;
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

@end
