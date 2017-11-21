//
//  ContractCreationEndOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"
#import "ContractCreationEndOutputDelegate.h"
#import "ResultTokenInputsModel.h"

@protocol ContractCreationEndOutput <Presentable>

@property (weak, nonatomic) id <ContractCreationEndOutputDelegate> delegate;
@property (copy, nonatomic) NSArray<ResultTokenInputsModel *> *inputs;

- (void)showErrorPopUp:(NSString *) string;

- (void)showCompletedPopUp;

- (void)setMinFee:(QTUMBigNumber *) minFee andMaxFee:(QTUMBigNumber *) maxFee;

- (void)setMinGasPrice:(QTUMBigNumber *) min andMax:(QTUMBigNumber *) max step:(long) step;

- (void)setMinGasLimit:(QTUMBigNumber *) min andMax:(QTUMBigNumber *) max standart:(QTUMBigNumber *) standart step:(long) step;

@end
