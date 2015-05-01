//
//  APIService.m
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "APIService.h"
#import "Constants.h"
#import <AFNetworking/AFNetworking.h>

@implementation APIService

+ (id)sharedManager
{
    static APIService *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super alloc] init];
    });
    return sharedManager;
}

- (void) createNewAccount:(NSString *)uuid email:(NSString *)email password:(NSString *)password onCompletion:(RequestCompletionHandler)complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: [NSString stringWithFormat:@"%d", RT2_REGISTERUSER], C_REQUEST_ID : uuid, @"user" : email, @"pass" : password};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];

}

- (void) signIn:(NSString *)uuid email:(NSString *)email password:(NSString *)password onCompletion:(RequestCompletionHandler)complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: [NSString stringWithFormat:@"%d", RT1_CHECKUSER], C_REQUEST_ID : uuid, @"user" : email, @"pass" : password};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];
    
}

- (void) resendConfirmEmail:(NSString *)uuid email:(NSString *)email onCompletion:(RequestCompletionHandler)complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: [NSString stringWithFormat:@"%d", RT3_RESENDVERIFICATIONEMAIL], C_REQUEST_ID : uuid, @"user" : email};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];
}

- (void) forgotPassword:(NSString *)uuid email:(NSString *)email onCompletion:(RequestCompletionHandler)complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: [NSString stringWithFormat:@"%d", RT13_FORGOTPASSWORD], C_REQUEST_ID : uuid, @"user" : email};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];
}

- (void) getCompanyData:(NSString *)uuid requestType:(NSString *)requestType requestBody:(NSString *)requestBody onCompletion :(RequestCompletionHandler)complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: requestType, C_REQUEST_ID : uuid, @"company" : requestBody};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];
}

- (void) getCardBalancePrepareData:(NSString *)uuid clientId:(NSString *)clientId company:(NSString *)company number:(NSString *)number accessCode:(NSString *)accessCode onCompletion:(RequestCompletionHandler)complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: [NSString stringWithFormat:@"%d", RT5_PREPARECARDBALANCE], C_REQUEST_ID : uuid, C_REQUEST_TIMEOUT : C_HTTP_DEFAULTTIMEOUT, @"clientid" : clientId, @"company" : company, @"number" : number, @"accesscode" : accessCode};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];
}

- (void) getCardBalanceData:(NSString *) uuid guid:(NSString *)guid onCompletion:(RequestCompletionHandler) complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: [NSString stringWithFormat:@"%d", RT6_GETCARDBALANCE], C_REQUEST_ID : uuid, @"guid" : guid};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];
}

- (void) getCardBalanceDataWithTransaction:(NSString *) uuid guid:(NSString *)guid onCompletion:(RequestCompletionHandler) complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: [NSString stringWithFormat:@"%d", RT9_GETCARDBALANCEWITHTRANSACTIONS], C_REQUEST_ID : uuid, @"guid" : guid};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];
}

- (void) getCardBalancePrepareDataWithTransaction:(NSString *)uuid clientId:(NSString *)clientId company:(NSString *)company number:(NSString *)number accessCode:(NSString *)accessCode onCompletion:(RequestCompletionHandler)complete {
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: [NSString stringWithFormat:@"%d", RT8_PREPARECARDBALANCEWITHTRANSACTIONS], C_REQUEST_ID : uuid, C_REQUEST_TIMEOUT : C_HTTP_DEFAULTTIMEOUT, @"clientid" : clientId, @"company" : company, @"number" : number, @"accesscode" : accessCode, @"count" : @"5"};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];
}

- (void) payWithCard:(NSString *)uuid cardId:(NSString *)cardId clientId:(NSString *)clientId company:(NSString *)company number:(NSString *)number accessCode:(NSString *)accessCode shopId:(NSString *)shopId slaveId:(NSString *)slaveId transguid:(NSString *)transguid ccv:(NSString *)ccv source:(NSString *)source onCompletion:(RequestCompletionHandler)complete {
    
    NSString *requestType;
    if([cardId isEqualToString:@"0"]) {
        requestType = [NSString stringWithFormat:@"%d", RT7_PAYWITHCARD];
    }
    else {
        requestType = [NSString stringWithFormat:@"%d", RT12_FASTPAYWITHCARD];
    }
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:C_CARD_POSTREQUESTS]];
    NSDictionary *parameters = @{C_REQUEST_TYPE: requestType, C_REQUEST_ID : uuid, @"clientid" : clientId, @"company" : company, @"number" : number, @"accesscode" : accessCode, @"shopid" : shopId, @"slaveid" : slaveId, @"transguid" : transguid, @"ccv" : ccv, @"source" : source};
    
    [httpClient postPath:C_CARD_POSTREQUESTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSString* strResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        complete(strResponse ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
        
    }];

}

@end
