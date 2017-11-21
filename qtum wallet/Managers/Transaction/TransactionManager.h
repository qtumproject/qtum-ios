//
//  TransactionManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 02.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionBuilder.h"

@interface TransactionManager : NSObject

- (void)sendTransactionWalletKeys:(NSArray<BTCKey *> *) walletKeys
			   toAddressAndAmount:(NSArray *) amountsAndAddresses
							  fee:(QTUMBigNumber *) fee
					   andHandler:(void (^)(TransactionManagerErrorType errorType,
							   id response,
							   QTUMBigNumber *estimatedFee)) completion;

- (void)createSmartContractWithKeys:(NSArray<BTCKey *> *) walletKeys
						 andBitcode:(NSData *) bitcode
								fee:(QTUMBigNumber *) fee
						   gasPrice:(QTUMBigNumber *) gasPrice
						   gasLimit:(QTUMBigNumber *) gasLimit
						 andHandler:(void (^)(TransactionManagerErrorType errorType, BTCTransaction *transaction, NSString *hashTransaction, QTUMBigNumber *estimatedValue)) completion;

- (void)callContractWithAddress:(NSData *) contractAddress
					 andBitcode:(NSData *) bitcode
				  fromAddresses:(NSArray<NSString *> *) fromAddresses
					  toAddress:(NSString *) toAddress
					 walletKeys:(NSArray<BTCKey *> *) walletKeys
							fee:(QTUMBigNumber *) fee
					   gasPrice:(QTUMBigNumber *) gasPrice
					   gasLimit:(QTUMBigNumber *) gasLimit
					 andHandler:(void (^)(TransactionManagerErrorType errorType,
							 BTCTransaction *transaction,
							 NSString *hashTransaction,
							 QTUMBigNumber *estimatedFee)) completion;

- (void)sendTransactionToToken:(Contract *) token
					 toAddress:(NSString *) toAddress
						amount:(QTUMBigNumber *) amount
						   fee:(QTUMBigNumber *) fee
					  gasPrice:(QTUMBigNumber *) gasPrice
					  gasLimit:(QTUMBigNumber *) gasLimit
					andHandler:(void (^)(TransactionManagerErrorType errorType,
							BTCTransaction *transaction,
							NSString *hashTransaction,
							QTUMBigNumber *estimatedFee)) completion;

- (void)sendToken:(Contract *) token
	  fromAddress:(NSString *) fromAddress
		toAddress:(NSString *) toAddress
		   amount:(QTUMBigNumber *) amount
			  fee:(QTUMBigNumber *) fee
		 gasPrice:(QTUMBigNumber *) gasPrice
		 gasLimit:(QTUMBigNumber *) gasLimit
	   andHandler:(void (^)(TransactionManagerErrorType errorType,
			   BTCTransaction *transaction,
			   NSString *hashTransaction,
			   QTUMBigNumber *estimatedFee)) completion;

- (void)getFeePerKbWithHandler:(void (^)(QTUMBigNumber *feePerKb)) completion;


@end
