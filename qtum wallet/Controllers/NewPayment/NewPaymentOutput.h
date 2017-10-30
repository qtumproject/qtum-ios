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

@class JKBigDecimal;

@protocol NewPaymentOutput <Presentable>

@property (weak, nonatomic) id <NewPaymentOutputDelegate> delegate;

- (void)setSendInfoItem:(SendInfoItem *)item;
- (void)updateControlsWithTokensExist:(BOOL) isExist
                    choosenTokenExist:(BOOL) choosenExist
                      walletBalance:(JKBigDecimal*) walletBalance
             andUnconfimrmedBalance:(JKBigDecimal*) walletUnconfirmedBalance;
- (void)updateContentWithContract:(Contract*) contract;
- (void)clearFields;
- (void)showErrorPopUp:(NSString *)message;
- (void)showCompletedPopUp;
- (void)showLoaderPopUp;
- (void)hideLoaderPopUp;
- (void)setMinFee:(NSNumber *)minFee andMaxFee:(NSNumber *)maxFee;
- (void)setMinGasPrice:(NSNumber *)min andMax:(NSNumber *)max step:(long)step;
- (void)setMinGasLimit:(NSNumber *)min andMax:(NSNumber *)max standart:(NSNumber *)standart step:(long)step;

@end
