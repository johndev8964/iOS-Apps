//
//  CompanysModel.m
//  CashAssistMobileCard
//
//  Created by User on 4/13/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "CompanysModel.h"

@implementation CompanyRecord

@synthesize recordid, modifiedno, company, name, logo, companyid;

@end

@implementation CompanysModel

@synthesize dbHandler;
@synthesize companysArray;

+ (BOOL)createTable:(sqlite3 *)dbHandler {
    NSString* strQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ INTEGER NOT NULL, %@ VARCHAR(%d) NOT NULL,  %@ VARCHAR(%d) NOT NULL,  %@ VARCHAR(%d) NOT NULL,  %@ VARCHAR(%d) NOT NULL)",
                          TABLE_COMPANYS,
                          FIELD_RECORDID,
                          FIELD_MODIFIEDNO,
                          FIELD_COMPANY, 255,
                          FIELD_NAME,     255,
                          FIELD_LOGO,     4000,
                          FIELD_COMPANYID,    255
                          ];
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

-(id)initWithDBHandler:(sqlite3*)_dbHandler {
    self = [super init];
    
    if (self) {
        self.dbHandler = _dbHandler;
        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@", TABLE_COMPANYS, FIELD_RECORDID];
        
        sqlite3_stmt* stmt;
        
        if (sqlite3_prepare_v2(dbHandler, [strQuery UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
            //int userId;
            companysArray = [[NSMutableArray alloc] init];
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                CompanyRecord * record = [[CompanyRecord alloc] init];
                record.recordid     = 0;
                record.modifiedno   = 0;
                record.company      = @"";
                record.name         = @"";
                record.logo         = @"";
                record.companyid    = @"";
                
                char *company = (char*)sqlite3_column_text(stmt, 2);
                char *name = (char*)sqlite3_column_text(stmt, 3);
                char *companyid = (char*)sqlite3_column_text(stmt, 5);
                char *logo =(char *) sqlite3_column_blob(stmt, 4);
                
                record.recordid = sqlite3_column_int(stmt, 0);
                
                if (company != nil)
                    record.company = [NSString stringWithUTF8String:company];
                
                if (name != nil)
                    record.name = [NSString stringWithUTF8String:name];
                
                if (companyid != nil)
                    record.companyid = [NSString stringWithUTF8String:companyid];
                
                if (logo != nil)
                    record.logo = [NSString stringWithUTF8String:logo];
                
                [companysArray addObject:record];
            }
            sqlite3_finalize(stmt);
        }
    }
    return self;
}

- (BOOL)updateDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_COMPANYS];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    for (int i = 0; i < [companysArray count]; i++) {
        CompanyRecord* record = (CompanyRecord*)[companysArray objectAtIndex:i];
        strQuery = [NSString stringWithFormat:@"INSERT INTO %@('%@','%@','%@','%@','%@') VALUES(%d,'%@','%@','%@','%@')",
                    TABLE_COMPANYS,
                    FIELD_MODIFIEDNO,
                    FIELD_COMPANY,
                    FIELD_NAME,
                    FIELD_LOGO,
                    FIELD_COMPANYID,
                    record.modifiedno,
                    record.company,
                    record.name,
                    record.logo,
                    record.companyid
                    ];
        
        if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
            return NO;
    }
    
    return YES;
}

- (BOOL) deleteDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_COMPANYS];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    return YES;
}

- (void) updateArray:(CompanyRecord*)data {
    for (CompanyRecord* record in companysArray) {
        if (record.company == data.company) {
            record.recordid     = data.recordid;
            record.modifiedno   = data.modifiedno;
            record.company      = data.company;
            record.name         = data.name;
            record.logo         = data.logo;
            record.companyid    = data.companyid;
            [self updateDB];
            break;
        }
    }
}

//- (BOOL)updateRecord:(CompanyRecord*)data {
//    NSString *strQuery = [NSString stringWithFormat:@"UPDATE %@  SET %@= %f WHERE %@ = %d",
//                  TABLE_COMPANYS,
//                  FIELD_COMPANY,
//                  data.company,
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

