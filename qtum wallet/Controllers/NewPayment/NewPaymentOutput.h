//
//  NewPaymentOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"
#import "NewPaymentOutputEntity.h"

@protocol NewPaymentOutputDelegate;

@protocol NewPaymentOutput <Presentable>

@property (weak, nonatomic) id <NewPaymentOutputDelegate> delegate;

- (void)setSendInfoItem:(SendInfoItem *) item;

- (void)updateContentWithContract:(Contract *) contract;

- (void)updateWithEtity:(NewPaymentOutputEntity *) entity;

- (void)clearFields;

- (void)startEditingAddress;

- (void)setMinFee:(QTUMBigNumber *) minFee andMaxFee:(QTUMBigNumber *) maxFee;

- (void)setMinGasPrice:(QTUMBigNumber *) min andMax:(QTUMBigNumber *) max step:(long) step;

- (void)setMinGasLimit:(QTUMBigNumber *) min andMax:(QTUMBigNumber *) max standart:(QTUMBigNumber *) standart step:(long) step;

@end
