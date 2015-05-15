//
//  CAMobileCardViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "CAMobileCardViewController.h"
#import "CardInfoViewController.h"
#import "AddCardViewController.h"
#import "AccountInfoViewController.h"
#import "AboutViewController.h"
#import "CardsTableViewCell.h"
#import "APIService.h"
#import "Constants.h"
#import "UIColor+HexString.h"
#import "Global.h"
#import "APIService.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <CocoaSecurity/CocoaSecurity.h>
#import "QrcodeScanViewController.h"

@interface CAMobileCardViewController ()

@property (nonatomic, retain) NSString *payCardCompany, *payCardClientID, *payCardClientSlaveID, *payCardTransactionGUID, *payCardCloudVersion;

@end

@implementation CAMobileCardViewController

@synthesize cardsList;
@synthesize cardBtn;
@synthesize cardLabel;
@synthesize paymentView;
@synthesize paymentBtn;
@synthesize paymentLabel;
@synthesize menuBtn;
@synthesize menuView;
@synthesize payCardStatus;
@synthesize qrScanBtn;
@synthesize payCardCompany, payCardClientID, payCardTransactionGUID, payCardClientSlaveID, payCardCloudVersion;
@synthesize selectNumberAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Global initDB];
    [self updateCompanyData];

    menuBtn.layer.cornerRadius = 4;
    menuBtn.clipsToBounds = YES;
    menuBtn.layer.borderWidth = 1;
    menuBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    qrScanBtn.layer.cornerRadius = 15;
    qrScanBtn.clipsToBounds = YES;
    qrScanBtn.layer.borderWidth = 1;
    qrScanBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    
    [menuView setHidden:YES];
    [paymentView setHidden:YES];
    [paymentLabel setHidden:YES];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [Global initDB];
    [payCardStatus setHidden:YES];
    [cardsList reloadData];
}

- (void) showPayCardStatus:(NSString *) status {
    [payCardStatus setHidden:NO];
    [payCardStatus setText:status];
}

- (IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) processPayWithCards:(NSString *)result {
    payCardCompany = [Global httpResponseParser:@"1" result:result];
    payCardClientID = [Global httpResponseParser:@"2" result:result];
    payCardClientSlaveID = [Global httpResponseParser:@"3" result:result];
    payCardTransactionGUID = [Global httpResponseParser:@"4" result:result];
    payCardCloudVersion = [Global httpResponseParser:@"5" result:result];
    
    if([payCardCompany isEqualToString:@""] || [payCardTransactionGUID isEqualToString:@""] || [payCardClientID isEqualToString:@"0"]) {
        [self showPayCardStatus:@"Error : Wrong decode result."];
    }
    else {
        g_Global = [[Global alloc] init];
        g_Global.payCardsArray = [[NSMutableArray alloc] init];
        
        for(CardRecord *_card in g_CardsModel.cardsArray) {
            if([_card.userid isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:USER_ID]] && [_card.company isEqualToString:payCardCompany]) {
                [g_Global.payCardsArray addObject:_card.number];
            }
        }
        
        if(g_Global.payCardsArray.count == 0) {
            [self showPayCardStatus:@"Error : No registered cards from this company in the you..."];
        }
        else if(g_Global.payCardsArray.count == 1) {
            [self payWithCardAssignSendRequest:[g_Global.payCardsArray objectAtIndex:0]];
        }
        else {
            selectNumberAlert = [[UIAlertView alloc] initWithTitle:@"Select" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            for (int i = 0; i < g_Global.payCardsArray.count; i++) {
                [selectNumberAlert addButtonWithTitle:[g_Global.payCardsArray objectAtIndex:i]];
            }
            [selectNumberAlert show];
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self payWithCardAssignSendRequest: [g_Global.payCardsArray objectAtIndex:buttonIndex - 1]];
 
}

- (void) payWithCardAssignSendRequest:(NSString *) vCardNumber {
    
    NSString *cardID;
    NSString *accessCode;
    NSString *userID;
    
    for (CardRecord *_card in g_CardsModel.cardsArray) {
        if([_card.number isEqualToString:vCardNumber] && [_card.company isEqualToString:payCardCompany]) {
            cardID = _card.cardid;
            userID = _card.userid;
            NSData *key = [C_MOBILE_KEY dataUsingEncoding:NSUTF8StringEncoding];
            NSData *vector = [C_MOBILE_VECTOR dataUsingEncoding:NSUTF8StringEncoding];
            CocoaSecurityResult *aes256Decrypt = [CocoaSecurity aesDecryptWithBase64:_card.accesscode key:key iv:vector];
            accessCode = aes256Decrypt.utf8String;
        }
    }
    
    NSString *udid = [[Global sharedManager] getNewUDID];
    UIDevice* currentDevice = [UIDevice currentDevice];
    NSString* model = [currentDevice model];
    [[APIService sharedManager] payWithCard:udid cardId:cardID clientId:userID company:payCardCompany number:vCardNumber accessCode:accessCode shopId:payCardClientID slaveId:payCardClientSlaveID transguid:[payCardTransactionGUID stringByReplacingOccurrencesOfString:@"[{}]" withString:@""] ccv:payCardCloudVersion source:model onCompletion:^(NSString *result, NSError *error) {
        if (!error) {
            int errorCode = [[Global httpResponseParser:C_REQUEST_ERRORCODE result:result] intValue];
            if(errorCode == 0) {
                [self showPayCardStatus:@"Operation completed successfully!"];
            }
            else {
                [self showPayCardStatus:[Global httpResponseParser:C_REQUEST_ERRORTEXT result:result]];
            }
        }
        else {
            [self showPayCardStatus:error.localizedDescription];
        }
    }];
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
        //menuView.layer.backgroundColor = [[UIColor blackColor] CGColor];
    }
    else {
        [menuView setHidden:YES];
    }
}

- (IBAction) showCardsTableView:(id)sender {
    [cardLabel setHidden:NO];
    [paymentView setHidden:YES];
    [paymentLabel setHidden:YES];
}

- (IBAction) showPayWithCardsView:(id)sender {
    [paymentView setHidden:NO];
    [cardLabel setHidden:YES];
    [paymentLabel setHidden:NO];
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
    CardsTableViewCell *cell = (CardsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CardsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if (g_CardsModel.cardsArray.count != 0) {
        CardRecord *cardRecord = [[CardRecord alloc] init];
        cardRecord = [g_CardsModel.cardsArray objectAtIndex:indexPath.row];
        [cell showCardRecord:cardRecord.number company:cardRecord.company];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CardsTableViewCell *cell = (CardsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CardInfoViewController *cardInfoViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardInfoView"];
    [self.navigationController pushViewController:cardInfoViewCtrl animated:NO];
    [cardInfoViewCtrl showDetails:cell.cardNumberLabel.text companyName:cell.companyLabel.text];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return g_CardsModel.cardsArray.count;
}

- (CGFloat) tableView : (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 70;
}


- (void) updateCompanyData {
    for (CompanyRecord *_companyRecord in g_CompanysModel.companysArray) {
        NSString *udid = [[Global sharedManager] getNewUDID];
        
        [[APIService sharedManager] getCompanyData:udid requestType: [NSString stringWithFormat:@"%d", RT4_GETCOMPANYDATA] requestBody:_companyRecord.company onCompletion:^(NSString *result, NSError *error){
            if (!error) {
                int errorCode = [[Global httpResponseParser:C_REQUEST_ERRORCODE result:result] intValue];
                
                if (errorCode == 0) {
                    switch ([[Global httpResponseParser:C_REQUEST_TYPE result:result] intValue]) {
                        case RT4_GETCOMPANYDATA:
                            _companyRecord.name = [Global httpResponseParser:@"name" result:result];
                            _companyRecord.logo = [[Global httpResponseParser:@"logo" result:result] dataUsingEncoding:NSUTF8StringEncoding];
                            _companyRecord.companyid = [Global httpResponseParser:@"companyid" result:result];
                            _companyRecord.modifiedno = [[Global httpResponseParser:@"mno" result:result] intValue];
                            _companyRecord.company = [Global httpResponseParser:@"company" result:result];
                            
                            [g_CompanysModel updateArray:_companyRecord];
                            break;
                        case RT10_GETCOMPANYMODIFIDEDNO:
                            
                            break;
                        default:
                            break;
                    }
                }
            }
            
        }];
        
        [g_CompanysModel updateDB];
    }
    
    [g_CompanysModel updateDB];
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
