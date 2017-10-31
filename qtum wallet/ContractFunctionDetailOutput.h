//
//  ContractFunctionDetailOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContractFunctionDetailOutputDelegate.h"
#import "Presentable.h"
#import "AbiinterfaceItem.h"

@protocol ContractFunctionDetailOutput <Presentable>

@property (weak,nonatomic) id <ContractFunctionDetailOutputDelegate> delegate;
@property (strong,nonatomic) AbiinterfaceItem* function;
@property (nonatomic) BOOL fromQStore;
@property (weak,nonatomic) Contract* token;

-(void)showResultViewWithOutputs:(NSArray*) outputs;

- (void)showLoader;
- (void)hideLoader;
- (void)showCompletedPopUp;
- (void)showErrorPopUp:(NSString *)message;
- (void)setMinFee:(QTUMBigNumber*) minFee andMaxFee:(QTUMBigNumber*) maxFee;
- (void)setMinGasPrice:(QTUMBigNumber *)min andMax:(QTUMBigNumber *)max step:(long)step;
- (void)setMinGasLimit:(QTUMBigNumber *)min andMax:(QTUMBigNumber *)max standart:(QTUMBigNumber *)standart step:(long)step;
- (void)showNotEnoughFeeAlertWithEstimatedFee:(QTUMBigNumber*) estimatedFee;

@end
