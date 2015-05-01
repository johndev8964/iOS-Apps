//
//  BetModel.h
//  MesParis
//
//  Created by Liming on 8/7/14.
//  Copyright (c) 2014 Liming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define TABLE_CARDS		@"tbl_cards"

#define FIELD_RECORDID      @"recordid"
#define FIELD_ACCESSCODE	@"accesscode"
#define FIELD_NUMBER		@"number"
#define FIELD_USERID	    @"userid"
#define FIELD_COMPANY		@"company"
#define FIELD_CARDID        @"cardid"

@interface CardRecord : NSObject {
    int recordid;
    NSString *accesscode;
    NSString *number;
    NSString *userid;
    NSString *company;
    NSString *cardid;
}

@property (nonatomic)         int       recordid;
@property (nonatomic, retain) NSString* accesscode;
@property (nonatomic, retain) NSString* number;
@property (nonatomic, retain) NSString* userid;
@property (nonatomic, retain) NSString* company;
@property (nonatomic, retain) NSString* cardid;

@end

@interface CardsModel : NSObject {
	sqlite3         *dbHandler;
    NSMutableArray  *cardsArray;
}

@property (nonatomic)           sqlite3         *dbHandler;
@property (nonatomic, retain)   NSMutableArray  *cardsArray;

+ (BOOL)createTable:(sqlite3 *)dbHandler;
- (id)initWithDBHandler:(sqlite3*)dbHandler;
- (BOOL)updateDB;
- (BOOL)deleteDB;
- (void)updateArray:(CardRecord*) data;

@end

