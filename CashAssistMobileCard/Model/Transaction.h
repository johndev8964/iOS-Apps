//
//  Transaction.h
//  CashAssistMobileCard
//
//  Created by User on 4/20/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject {
    int transactionID;
    NSString *c1_AlutaDatumZeit;
    NSString *c2_BelegNr;
    NSString *c3_Number;
    NSString *c4_Bezeichnung;
    
    long c5_SollOrHaben;
    long c6_Saldo;
    int  c7_Points;
    int  c8_TotalPoints;
}

@property (nonatomic) int transactionID;
@property (nonatomic, retain) NSString *c1_AlutaDatumZeit;
@property (nonatomic, retain) NSString *c2_BelegNr;
@property (nonatomic, retain) NSString *c3_Number;
@property (nonatomic, retain) NSString *c4_Bezeichnung;

@property (nonatomic) long c5_SollOrHaben;
@property (nonatomic) long c6_Saldo;
@property (nonatomic) int c7_Points;
@property (nonatomic) int c8_TotalPoints;

@end