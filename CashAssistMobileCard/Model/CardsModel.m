//
//  BetModel.m
//  MesParis
//
//  Created by Liming on 8/7/14.
//  Copyright (c) 2014 Liming. All rights reserved.
//

#import "CardsModel.h"

@implementation CardRecord

@synthesize recordid, accesscode, number, userid, company, cardid;

@end

@implementation CardsModel

@synthesize dbHandler;
@synthesize cardsArray;

+ (BOOL)createTable:(sqlite3 *)dbHandler {
	NSString* strQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ INTEGER PRIMARY KEY AUTOINCREMENT,  %@ VARCHAR(%d) NOT NULL,  %@ VARCHAR(%d) NOT NULL,  %@ VARCHAR(%d) NOT NULL,  %@ VARCHAR(%d) NOT NULL, %@ VARCHAR(%d) NOT NULL)",
						  TABLE_CARDS,
                          FIELD_RECORDID,
                          FIELD_ACCESSCODE, 255,
                          FIELD_NUMBER,     255,
                          FIELD_USERID,     255,
                          FIELD_COMPANY,    255,
                          FIELD_CARDID,     255
                          ];
	if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
		return NO;
	
	return YES;
}

-(id)initWithDBHandler:(sqlite3*)_dbHandler {
	self = [super init];
	
	if (self) {
		self.dbHandler = _dbHandler;
		NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@", TABLE_CARDS, FIELD_RECORDID];
        
		sqlite3_stmt* stmt;
		
		if (sqlite3_prepare_v2(dbHandler, [strQuery UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
			//int userId;
            cardsArray = [[NSMutableArray alloc] init];
			while(sqlite3_step(stmt) == SQLITE_ROW) {
                CardRecord * record = [[CardRecord alloc] init];
                record.recordid     = 0;
                record.accesscode   = @"";
                record.number       = @"";
                record.userid       = @"";
                record.company      = @"";
                record.cardid       = @"";
                
                char *accesscode = (char*)sqlite3_column_text(stmt, 1);
				char *number = (char*)sqlite3_column_text(stmt, 2);
                char *userid = (char*)sqlite3_column_text(stmt, 3);
                char *company = (char*)sqlite3_column_text(stmt, 4);
				char *cardid = (char*)sqlite3_column_text(stmt, 5);
                
                record.recordid = sqlite3_column_int(stmt, 0);
                
				if (accesscode != nil)
					record.accesscode = [NSString stringWithUTF8String:accesscode];
                
                if (number != nil)
					record.number = [NSString stringWithUTF8String:number];
                
                if (userid != nil)
                    record.userid = [NSString stringWithUTF8String:userid];
                
                if (company != nil)
                    record.company = [NSString stringWithUTF8String:company];
				
                if (cardid != nil) {
                    record.cardid = [NSString stringWithUTF8String:cardid];
                }
                
                [cardsArray addObject:record];
			}
            sqlite3_finalize(stmt);
		}
	}
	return self;
}

- (BOOL)updateDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_CARDS];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    for (int i = 0; i < [cardsArray count]; i++) {
        CardRecord* record = (CardRecord*)[cardsArray objectAtIndex:i];
        strQuery = [NSString stringWithFormat:@"INSERT INTO %@('%@','%@','%@','%@','%@') VALUES('%@','%@','%@','%@','%@')",
                    TABLE_CARDS,
                    FIELD_ACCESSCODE,
                    FIELD_NUMBER,
                    FIELD_USERID,
                    FIELD_COMPANY,
                    FIELD_CARDID,
                    record.accesscode,
                    record.number,
                    record.userid,
                    record.company,
                    record.cardid
                ];
        
        if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
            return NO;
    }
    
    return YES;
}

- (BOOL) deleteDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_CARDS];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    return YES;
}

- (void)updateArray:(CardRecord*)data {
    for (CardRecord* record in cardsArray) {
        if (record.recordid == data.recordid) {
            record.recordid   = data.recordid;
            record.accesscode = data.accesscode;
            record.number     = data.number;
            record.userid     = data.userid;
            record.company    = data.company;
            record.cardid     = data.cardid;
            [self updateDB];
            break;
        }
    }
}

//- (BOOL)updateRecord:(BetRecord*)data {
//    NSString *strQuery = [NSString stringWithFormat:@"UPDATE %@  SET %@= %f WHERE %@ = %d",
//                  TABLE_BET,
//                  FIELD_BUDGET,
//                  data.budget,
//                  FIELD_ID,
//                  data.index
//    ];
//    
//    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
//        return NO;
//    return YES;
//}

- (void)dealloc {
	// release memory of resultController instance
}

@end

