//
//  NewPaymentOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JKBigDecimal;

@protocol NewPaymentOutputDelegate <NSObject>

- (void)didPresseQRCodeScaner;
- (void)didPresseChooseToken;
- (void)didPresseSendActionWithAddress:(NSString*) address
                             andAmount:(JKBigDecimal*) amount
                                   fee:(NSNumber*) fee
                              gasPrice:(NSNumber*) gasPrice
                              gasLimit:(NSNumber*) gasLimit;
- (void)didViewLoad;

- (BOOL)needCheckForChanges;
- (void)changeToStandartOperation;

@end
