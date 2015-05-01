//
//  DatabaseInterface.m
//  Cinema
//
//  Created by System Administrator on 23.1.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DBHandler.h"
#import "CardsModel.h"
#import "CompanysModel.h"

@implementation DBHandler

@synthesize dbHandler;

+ (id) connectDB {
	DBHandler *newInterface = [[DBHandler alloc] init];
	NSString* db_path = [documentPath stringByAppendingPathComponent:DB_NAME];
	int result = sqlite3_open([db_path UTF8String], &(newInterface->dbHandler));
	
    if (result != SQLITE_OK || ![CardsModel createTable:newInterface->dbHandler] || ![CompanysModel createTable:newInterface->dbHandler]) {
		return nil;
	}
	return newInterface;
}

- (void) disconnectDB {
	sqlite3_close(dbHandler);
}

- (void)dealloc {
	[self disconnectDB];
}

@end
