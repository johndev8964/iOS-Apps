//
//  APIService.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIService : NSObject

+ (id)sharedManager;

typedef void(^RequestCompletionHandler)(NSString *result, NSError *error);
typedef void(^RequestCompletionHandler1)(NSArray *result, NSError *error);

- (void) createNewAccount:(NSString *) uuid email:(NSString *)email password:(NSString *)password onCompletion:(RequestCompletionHandler) complete;
- (void) resendConfirmEmail:(NSString *) uuid email:(NSString *) email onCompletion:(RequestCompletionHandler) complete;
- (void) signIn:(NSString *) uuid email:(NSString *)email password:(NSString *)password onCompletion:(RequestCompletionHandler) complete;
- (void) forgotPassword:(NSString *) uuid email:(NSString *) email onCompletion:(RequestCompletionHandler) complete;
- (void) getCompanyData:(NSString *) uuid requestType:(NSString *)requestType requestBody:(NSString *) requestBody onCompletion:(RequestCompletionHandler) complete;
- (void) getCardBalancePrepareData:(NSString *) uuid clientId:(NSString *) clientId company:(NSString *) company number:(NSString *) number accessCode:(NSString *) accessCode onCompletion:(RequestCompletionHandler) complete;
- (void) getCardBalanceData:(NSString *) uuid guid:(NSString *)guid onCompletion:(RequestCompletionHandler) complete;
- (void) getCardBalancePrepareDataWithTransaction:(NSString *) uuid clientId:(NSString *) clientId company:(NSString *) company number:(NSString *) number accessCode:(NSString *) accessCode onCompletion:(RequestCompletionHandler) complete;
- (void) getCardBalanceDataWithTransaction:(NSString *) uuid guid:(NSString *)guid onCompletion:(RequestCompletionHandler) complete;
- (void) payWithCard:(NSString *) uuid cardId:(NSString *) cardId clientId:(NSString *) clientId company:(NSString * ) company number:(NSString *) number accessCode:(NSString *) accessCode shopId:(NSString *) shopId slaveId:(NSString *) slaveId transguid:(NSString *) transguid ccv:(NSString *) ccv source:(NSString *) source  onCompletion:(RequestCompletionHandler) complete;

@end
