//
//  CompanysModel.h
//  CashAssistMobileCard
//
//  Created by User on 4/13/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define TABLE_COMPANYS		@"tbl_companys"

#define FIELD_RECORDID      @"recordid"
#define FIELD_MODIFIEDNO	@"modifiedno"
#define FIELD_COMPANY		@"company"
#define FIELD_NAME	        @"name"
#define FIELD_LOGO  		@"logo"
#define FIELD_COMPANYID     @"companyid"

@interface CompanyRecord : NSObject {
    int recordid;
    int modifiedno;
    NSString *company;
    NSString *name;
    NSString *logo;
    NSString *companyid;
}

@property (nonatomic)         int       recordid;
@property (nonatomic)         int       modifiedno;
@property (nonatomic, retain) NSString  *company;
@property (nonatomic, retain) NSString  *name;
@property (nonatomic, retain) NSString  *logo;
@property (nonatomic, retain) NSString  *companyid;


@end

@interface CompanysModel : NSObject{
    sqlite3         *dbHandler;
    NSMutableArray  *companysArray;
}

@property (nonatomic)           sqlite3         *dbHandler;
@property (nonatomic, retain)   NSMutableArray  *companysArray;

+ (BOOL)createTable:(sqlite3 *)dbHandler;
- (id)initWithDBHandler:(sqlite3*)dbHandler;
- (BOOL)updateDB;
- (BOOL)deleteDB;
- (void)updateArray:(CompanyRecord*) data;

@end
