//
//  Global.m
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "Global.h"
#import "Constants.h"
#import <Toast/UIView+Toast.h>

Global *g_Global = nil;
DBHandler *g_DBHandler = nil;
CardsModel  *g_CardsModel = nil;
CompanysModel *g_CompanysModel = nil;

@implementation Global

+ (id)sharedManager
{
    static Global *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super alloc] init];
    });
    return sharedManager;
}

- (NSString *) getNewUDID
{
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = (__bridge NSString *)newUniqueIDString;
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    return([guid lowercaseString]);
}

- (NSString *) getDateTimeAsString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

- (NSString *) getOperationTypeDescrytion:(int)operationType {
    switch (operationType) {
            
        case OT1_REGISTERCARD:
            return @"Add a card";
            
        case OT2_PAYWITHCARD:
            return @"Pay with card";
            
        default:
            return @"Unknown type";

    }
}

- (NSString *) convertDateFormatToString:(NSString *)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss:SSS"];
    NSDate *date = [formatter dateFromString:str];
    NSString *newDate = [formatter stringFromDate:date];
    return newDate;
}

+ (void) initDB {
    g_DBHandler = [DBHandler connectDB];
    sqlite3* dbHandler = [g_DBHandler getDbHandler];
    g_CardsModel = [[CardsModel alloc] initWithDBHandler:dbHandler];
    g_CompanysModel = [[CompanysModel alloc] initWithDBHandler:dbHandler];
}

+ (void) showAlert:(NSString *)title description:(NSString *)description view:(UIView*) view
{
    [view makeToast:description duration:2 position:CSToastPositionBottom title:title];
}

+ (void) pageFlip:(UIViewController *) fromController to:(UIViewController *)toController
{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:fromController.navigationController.view cache:NO];
    [fromController.navigationController pushViewController:toController animated:YES];
    [UIView commitAnimations];
}

+ (BOOL) isValidEmail:(NSString *)email
{
    NSString *regex1 = @"\\A[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,4}\\z";
    NSString *regex2 = @"^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*";
    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [test1 evaluateWithObject:email] && [test2 evaluateWithObject:email];
}

+ (BOOL) isValidPassword:(NSString *)password
{
    if (password.length < 6)
    {
        return false;
    }
    else
    {
        BOOL nonCharacterExist = false;
        BOOL digitExist        = false;
        BOOL upperCaseExist    = false;
        BOOL lowerCaseExist    = false;
        
        NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
        NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                               characterSetWithCharactersInString:specialCharacterString];
        if([password rangeOfCharacterFromSet:specialCharacterSet].location != NSNotFound) {
            nonCharacterExist = true;
        }
        
        NSString *lowerCharacterString = @"abcdefghijklmnopqrstuvwxyz";
        NSCharacterSet *lowerCharacterSet = [NSCharacterSet
                                               characterSetWithCharactersInString:lowerCharacterString];
        if([password rangeOfCharacterFromSet:lowerCharacterSet].location != NSNotFound) {
            lowerCaseExist = true;
        }
        
        NSString *upperCharacterString = @"ABCDEFGHIJKLKMNOPQRSTUVWXYZ";
        NSCharacterSet *upperCharacterSet = [NSCharacterSet
                                             characterSetWithCharactersInString:upperCharacterString];
        if([password rangeOfCharacterFromSet:upperCharacterSet].location != NSNotFound) {
            upperCaseExist = true;
        }
        
        NSString *numberCharacterString = @"0123456789";
        NSCharacterSet *numberCharacterSet = [NSCharacterSet
                                             characterSetWithCharactersInString:numberCharacterString];
        if([password rangeOfCharacterFromSet:numberCharacterSet].location != NSNotFound) {
            digitExist = true;
        }
        
        if (nonCharacterExist && lowerCaseExist && upperCaseExist && digitExist) {
            return true;
        }
        
        return false;
    }
}

+ (NSString *) httpResponseParser:(NSString *)key result:(NSString *)result
{
    NSArray *items = [result componentsSeparatedByString:@"|"];
    
    for (NSString* item in items) {
        NSArray *keyItem = [item componentsSeparatedByString:@"="];
        if ([key isEqualToString:[keyItem objectAtIndex:0]]) {
            return [keyItem objectAtIndex:1];
        }
    }
    
    return nil;
}

+ (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
