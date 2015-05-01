//
//  Constants.h
//  CashAssistMobileCard
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#ifndef CashAssistMobileCard_Constants_h
#define CashAssistMobileCard_Constants_h

#define C_CARD_POSTREQUESTS                         @"https://card.cashassist.com/Services/PostRequests.asmx/Process"

#define C_REQUEST_ID                                @"_rid"
#define C_REQUEST_TYPE                              @"_type"
#define C_REQUEST_TIMEOUT                           @"_tot"
#define C_REQUEST_ERRORCODE                         @"_errc"
#define C_REQUEST_ERRORTEXT                         @"_errt"

#define C_HTTP_DEFAULTTIMEOUT                       @"10"

#define C_MOBILE_KEY                                @"4C7CE360B8FD4D1D8C9AD92A24E804AC"
#define C_MOBILE_VECTOR                             @"7391048116435787"

#define RT1_CHECKUSER                               1
#define RT2_REGISTERUSER                            2
#define RT3_RESENDVERIFICATIONEMAIL                 3
#define RT4_GETCOMPANYDATA                          4
#define RT5_PREPARECARDBALANCE                      5
#define RT6_GETCARDBALANCE                          6
#define RT7_PAYWITHCARD                             7
#define RT8_PREPARECARDBALANCEWITHTRANSACTIONS      8
#define RT9_GETCARDBALANCEWITHTRANSACTIONS          9
#define RT10_GETCOMPANYMODIFIDEDNO                  10
#define RT11_GETCOMPANYADVERTISEMENT                11
#define RT12_FASTPAYWITHCARD                        12
#define RT13_FORGOTPASSWORD                         13

#define OT0_UNKNOWN                                 0
#define OT1_REGISTERCARD                            1
#define OT2_PAYWITHCARD                             2

#define USER_EMAIL                                  @"USER_EMAIL"
#define USER_PASSWORD                               @"USER_PASSWORD"
#define USER_ID                                     @"USER_ID"

#endif
