//
//  Global.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DBHandler.h"
#import "CardsModel.h"
#import "CompanysModel.h"

@interface Global : NSObject

@property (nonatomic, retain) NSMutableArray *transactionsArray;
@property (nonatomic, retain) NSMutableArray *payCardsArray;

+ (id)sharedManager;

- (NSString *) getNewUDID;
- (NSString *) getDateTimeAsString;
- (NSString *) getOperationTypeDescrytion:(int) operationType;
- (NSString *) convertDateFormatToString:(NSString *)str;

+ (void) initDB;

+ (BOOL) isValidEmail:(NSString *) email;
+ (BOOL) isValidPassword:(NSString *) password;
+ (NSString *) httpResponseParser:(NSString *) key result:(NSString *) result;
+ (NSString *) base64String:(NSString *)str;

+ (void) showAlert:(NSString *) title description:(NSString *) description view:(UIView *) view;
+ (void) pageFlip:(UIViewController *) fromController to:(UIViewController *) toController;

@end

extern Global *g_Global;
extern DBHandler *g_DBHandler;
extern CardsModel  *g_CardsModel;
extern CompanysModel *g_CompanysModel;