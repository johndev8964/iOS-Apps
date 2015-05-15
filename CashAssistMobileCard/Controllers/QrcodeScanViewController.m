//
//  QrcodeScanViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/12/15.
//  Copyright (c) 2015 liming. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "QrcodeScanViewController.h"
#import "AddCardViewController.h"
#import "CAMobileCardViewController.h"
#import "Global.h"
#import "Constants.h"
#import "APIService.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface QrcodeScanViewController ()

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, weak) IBOutlet UIView *scanRectView;
@property (nonatomic, weak) IBOutlet UILabel *decodedLabel;

@end

@implementation QrcodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    [self.view bringSubviewToFront:self.cancelBtn];
    
    [Global initDB];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self.capture stop];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //[self.capture start];
        [self getQRCode:result];
    });
}

- (void) getQRCode : (ZXResult *) result {
    NSString *qrCode = result.text;
    
    if ([qrCode isEqualToString: @""]) {
        [Global showAlert:@"Alert" description:@"Canceled" view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if ([[qrCode substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]) {
            int vPos = (int) [qrCode rangeOfString:@"?"].location;
            
            if( vPos != -1 && qrCode.length > vPos + 1 ) {
                qrCode = [qrCode substringFromIndex:vPos + 1];
            }
        }
        
        NSData *key = [C_MOBILE_KEY dataUsingEncoding:NSUTF8StringEncoding];
        NSData *vector = [C_MOBILE_VECTOR dataUsingEncoding:NSUTF8StringEncoding];
        CocoaSecurityResult *aes256Decrypt = [CocoaSecurity aesDecryptWithBase64:qrCode key:key iv:vector];
        NSString *vDecrypted = aes256Decrypt.utf8String;
        
        int operationType = [[Global httpResponseParser:@"0" result:vDecrypted] intValue];
        
        if (operationType != OT0_UNKNOWN && operationType != OT1_REGISTERCARD && operationType != OT2_PAYWITHCARD) {
            [Global showAlert:@"Error" description:[NSString stringWithFormat:@"This QR Code is for other operation - %@", [[Global sharedManager] getOperationTypeDescrytion:operationType]] view:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        else {
            switch (operationType) {
                case OT1_REGISTERCARD:
                    [Global showAlert:@"Alert" description:[NSString stringWithFormat:@"Process request:%@", [[Global sharedManager] getOperationTypeDescrytion:operationType]] view:self.view];
                    [self registerCards:vDecrypted];
                    break;
                    
                case OT2_PAYWITHCARD:
                    [self processPayWithCard:vDecrypted];
                    break;
                    
                default:
                    [Global showAlert:@"Error" description:@"Unknown QR-Code" view:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
            }
        }
        
    }
}

- (void) processPayWithCard:(NSString *) result {
    [self.navigationController popViewControllerAnimated:YES];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CAMobileCardViewController *mobileCardViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"MobileCardView"];
    [mobileCardViewCtrl processPayWithCards:result];
}

- (IBAction) goCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) registerCards:(NSString *) qrCode {
    NSString *number = [Global httpResponseParser:@"1" result:qrCode];
    NSString *accessCode = [Global httpResponseParser:@"2" result:qrCode];
    NSString *company = [Global httpResponseParser:@"3" result:qrCode];
    
    if([number isEqualToString:@""] || [accessCode isEqualToString:@""] || [company isEqualToString:@""]) {
        [Global showAlert:@"Error" description:[NSString stringWithFormat:@"Wrong decode result."] view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        BOOL newCard = true;
        for (CardRecord *_cardRecord in g_CardsModel.cardsArray) {
            if ([number isEqualToString:_cardRecord.number]) {
                newCard = false;
            }
        }
        
        if (newCard) {
            CardRecord *cardRecord = [[CardRecord alloc] init];
            cardRecord.number = number;
            
            NSData *key = [C_MOBILE_KEY dataUsingEncoding:NSUTF8StringEncoding];
            NSData *vector = [C_MOBILE_VECTOR dataUsingEncoding:NSUTF8StringEncoding];
            CocoaSecurityResult *aes256 = [CocoaSecurity aesEncrypt:accessCode
                                                             key:key
                                                              iv:vector];
            
            cardRecord.accesscode = aes256.base64;
            cardRecord.company = company;
            cardRecord.userid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_ID];
            [g_CardsModel.cardsArray addObject:cardRecord];
            [g_CardsModel updateDB];
            
            BOOL newCompany = true;
            for (CompanyRecord *_companyRecord in g_CompanysModel.companysArray) {
                if([_companyRecord.company isEqualToString:company]) {
                    newCompany = false;
                }
            }
            
            if(newCompany) {
                NSString *udid = [[Global sharedManager] getNewUDID];
                
                [[APIService sharedManager] getCompanyData:udid requestType: [NSString stringWithFormat:@"%d", RT4_GETCOMPANYDATA] requestBody:company onCompletion:^(NSString *result, NSError *error){
                    if (!error) {
                        int errorCode = [[Global httpResponseParser:C_REQUEST_ERRORCODE result:result] intValue];
                        
                        if (errorCode == 0) {
                            switch ([[Global httpResponseParser:C_REQUEST_TYPE result:result] intValue]) {
                                case RT4_GETCOMPANYDATA:
                                    [self addCompanyData:result];
                                    [self performSelector:@selector(goMobileCard)];
                                    break;
                                case RT10_GETCOMPANYMODIFIDEDNO:
                                    [self addCompanyData:result];
                                    [self performSelector:@selector(goMobileCard)];
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    
                }];
            }
            else {
                [self performSelector:@selector(goMobileCard)];
            }
        }
        else {
            [self performSelector:@selector(goMobileCard)];
        }
        
        
    }
}

- (void) goMobileCard {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CAMobileCardViewController *mobileCardViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"MobileCardView"];
    [self.navigationController pushViewController:mobileCardViewCtrl animated:YES];

}
- (void) addCompanyData:(NSString *) result {
    
    CompanyRecord *companyRecord = [[CompanyRecord alloc] init];
    companyRecord.name = [Global httpResponseParser:@"name" result:result];
    
    
//    NSString* homeDir = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Test"];
//    [[NSFileManager defaultManager] createDirectoryAtPath:homeDir withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    NSError* error = nil;
//    [[Global httpResponseParser:@"logo" result:result] writeToFile:[homeDir stringByAppendingPathComponent:@"test.png"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    NSString *base64String = [Global httpResponseParser:@"logo" result:result];
    NSData *logoImage = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    companyRecord.logo = logoImage;
    
    //[companyRecord.logo writeToFile:[homeDir stringByAppendingPathComponent:@"test1.png"] atomically:YES];
    
    companyRecord.companyid = [Global httpResponseParser:@"companyid" result:result];
    companyRecord.modifiedno = [[Global httpResponseParser:@"mno" result:result] intValue];
    companyRecord.company = [Global httpResponseParser:@"company" result:result];
    
    [g_CompanysModel.companysArray addObject:companyRecord];
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
