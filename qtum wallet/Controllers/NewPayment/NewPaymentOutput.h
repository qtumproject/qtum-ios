//
//  NewPaymentOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"

@protocol NewPaymentOutputDelegate;

@protocol NewPaymentOutput <Presentable>

@property (weak, nonatomic) id <NewPaymentOutputDelegate> delegate;

- (void)setSendInfoItem:(SendInfoItem *)item;
- (void)updateControlsWithTokensExist:(BOOL) isExist
                    choosenTokenExist:(BOOL) choosenExist
                      walletBalance:(QTUMBigNumber*) walletBalance
             andUnconfimrmedBalance:(QTUMBigNumber*) walletUnconfirmedBalance;
- (void)updateContentWithContract:(Contract*) contract;
- (void)clearFields;
- (void)showErrorPopUp:(NSString *)message;
- (void)showCompletedPopUp;
- (void)showLoaderPopUp;
- (void)hideLoaderPopUp;
- (void)setMinFee:(QTUMBigNumber *)minFee andMaxFee:(QTUMBigNumber *)maxFee;
- (void)setMinGasPrice:(QTUMBigNumber *)min andMax:(QTUMBigNumber *)max step:(long)step;
- (void)setMinGasLimit:(QTUMBigNumber *)min andMax:(QTUMBigNumber *)max standart:(QTUMBigNumber *)standart step:(long)step;

@end
