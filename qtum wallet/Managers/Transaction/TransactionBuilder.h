//
//  TransactionBuilder.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.09.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionScriptBuilder.h"

typedef NS_ENUM(NSInteger, TransactionManagerErrorType) {
	TransactionManagerErrorTypeNone,
	TransactionManagerErrorTypeNoInternetConnection,
	TransactionManagerErrorTypeServer,
	TransactionManagerErrorTypeOups,
	TransactionManagerErrorTypeNotEnoughMoney,
	TransactionManagerErrorTypeNotEnoughMoneyOnAddress,
	TransactionManagerErrorTypeNotEnoughFee,
	TransactionManagerErrorTypeNotEnoughGasLimit,
	TransactionManagerErrorTypeInvalidAddress
};

@interface TransactionBuilder : NSObject

- (instancetype)initWithScriptBuilder:(TransactionScriptBuilder *) scriptBuilder;

- (BTCTransaction *)smartContractCreationTxWithUnspentOutputs:(NSArray *) unspentOutputs
												   withAmount:(NSInteger) amount
												  withBitcode:(NSData *) bitcode
													  withFee:(NSInteger) fee
												 withGasLimit:(QTUMBigNumber *) gasLimit
												 withGasprice:(QTUMBigNumber *) gasPrice
											   withWalletKeys:(NSArray<BTCKey *> *) walletKeys;

- (void)callContractTxWithUnspentOutputs:(NSArray <BTCTransactionOutput *> *) unspentOutputs
								  amount:(NSInteger) amount
						 contractAddress:(NSData *) contractAddress
							   toAddress:(NSString *) toAddress
						   fromAddresses:(NSArray<NSString *> *) fromAddresses
								 bitcode:(NSData *) bitcode
								 withFee:(NSInteger) fee
							withGasLimit:(QTUMBigNumber *) gasLimit
							withGasprice:(QTUMBigNumber *) gasPrice
							  walletKeys:(NSArray<BTCKey *> *) walletKeys
							  andHandler:(void (^)(TransactionManagerErrorType errorType, BTCTransaction *transaction)) completion;

- (void)regularTransactionWithUnspentOutputs:(NSArray <BTCTransactionOutput *> *) unspentOutputs
									  amount:(NSInteger) amount
						  amountAndAddresses:(NSArray *) amountAndAddresses
									 withFee:(NSInteger) fee
								  walletKeys:(NSArray<BTCKey *> *) walletKeys
								  andHandler:(void (^)(TransactionManagerErrorType errorType, BTCTransaction *transaction)) completion;

@end
