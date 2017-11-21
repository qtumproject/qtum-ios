//
//  NewPaymentOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewPaymentOutputDelegate <NSObject>

- (void)didPresseQRCodeScaner;

- (void)didPresseChooseToken;

- (void)didPresseSendActionWithAddress:(NSString *) address
							 andAmount:(QTUMBigNumber *) amount
								   fee:(QTUMBigNumber *) fee
							  gasPrice:(QTUMBigNumber *) gasPrice
							  gasLimit:(QTUMBigNumber *) gasLimit;

- (void)didViewLoad;

- (BOOL)needCheckForChanges;

- (void)changeToStandartOperation;

@end
