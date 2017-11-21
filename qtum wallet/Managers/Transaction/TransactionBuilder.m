//
//  TransactionBuilder.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.09.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BTCTransactionInput+Extension.h"
#import "BTCTransactionOutput+Address.h"

@interface TransactionBuilder ()

@property (strong, nonatomic) TransactionScriptBuilder *scriptBuilder;

@end

@implementation TransactionBuilder

- (instancetype)initWithScriptBuilder:(TransactionScriptBuilder *) scriptBuilder {

	self = [super init];
	if (self) {

		_scriptBuilder = scriptBuilder;
	}
	return self;
}

- (void)regularTransactionWithUnspentOutputs:(NSArray <BTCTransactionOutput *> *) unspentOutputs
									  amount:(NSInteger) amount
						  amountAndAddresses:(NSArray *) amountAndAddresses
									 withFee:(NSInteger) fee
								  walletKeys:(NSArray<BTCKey *> *) walletKeys
								  andHandler:(void (^)(TransactionManagerErrorType errorType, BTCTransaction *transaction)) completion {

	NSArray *utxos = unspentOutputs;
	if (utxos.count > 0) {

		// Find enough outputs to spend the total amount and FEE.
		BTCAmount totalAmount = amount + fee;

		// Sort utxo in order of
		utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput *obj1, BTCTransactionOutput *obj2) {
			if (obj1.value > obj2.value) {
				return NSOrderedAscending;
			} else {
				return NSOrderedDescending;
			}
		}];

		NSMutableArray *txouts = [[NSMutableArray alloc] init];
		NSInteger total = 0;

		for (BTCTransactionOutput *txout in utxos) {

			if ([txout.script isPayToPublicKeyHashScript]) {
				[txouts addObject:txout];
				total += txout.value;
			}
			if (total >= (totalAmount)) {
				break;
			}
		}

		if (total < totalAmount) {
			if (unspentOutputs.count > 1) {
				completion (TransactionManagerErrorTypeNotEnoughMoney, nil);
			} else {
				completion (TransactionManagerErrorTypeNotEnoughMoneyOnAddress, nil);
			}
			return;
		}

		// Create a new transaction
		BTCTransaction *tx = [[BTCTransaction alloc] init];
		tx.fee = fee;
		BTCAmount spentCoins = 0;

		// Add all outputs as inputs
		for (BTCTransactionOutput *txout in txouts) {
			BTCTransactionInput *txin = [[BTCTransactionInput alloc] init];
			txin.previousHash = txout.transactionHash;
			txin.previousIndex = txout.index;
			[tx addInput:txin];
			spentCoins += txout.value;
		}

		// Add required outputs - payment and change
		for (NSDictionary *dictionary in amountAndAddresses) {
			BTCPublicKeyAddress *toPublicKeyAddress = dictionary[@"address"];
			BTCAmount amount = [dictionary[@"amount"] longLongValue];

			BTCTransactionOutput *paymentOutput;
			paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount address:toPublicKeyAddress];
			[tx addOutput:paymentOutput];
		}

		BTCAddress *changeAddress = SLocator.appSettings.isMainNet ? walletKeys.firstObject.address : walletKeys.firstObject.addressTestnet;
		BTCTransactionOutput *changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - totalAmount) address:changeAddress];

		if (changeOutput.value > 0) {
			[tx addOutput:changeOutput];
		}

		// Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
		for (int i = 0; i < txouts.count; i++) {
			// Normally, we have to find proper keys to sign this txin, but in this
			// example we already know that we use a single private key.

			BTCTransactionOutput *txout = txouts[i];
			BTCTransactionInput *txin = tx.inputs[i];
			BTCScript *sigScript = [[BTCScript alloc] init];
			NSData *d1 = tx.data;
			NSData *hash = [tx signatureHashForScript:txout.script inputIndex:i hashType:BTCSignatureHashTypeAll error:nil];
			DLog(@"Hash Sig: %@", BTCIDFromHash (hash));
			NSData *d2 = tx.data;

			NSAssert([d1 isEqual:d2], @"Transaction must not change within signatureHashForScript!");

			if (!hash) {
				completion (TransactionManagerErrorTypeOups, nil);
				return;
			}

			BTCKey *key;
			for (BTCKey *someKey in walletKeys) {
				NSString *keyString = someKey.address.string;// SLocator.appSettings.isMainNet ? someKey.address.string : someKey.addressTestnet.string;
				if ([keyString isEqualToString:txout.script.standardAddress.string]) {
					key = someKey;
					break;
				}
			}
			if (!key) {
				completion (TransactionManagerErrorTypeOups, nil);
				return;
			}

			NSData *signature = [key signatureForHash:hash];

			NSMutableData *signatureForScript = [signature mutableCopy];
			unsigned char hashtype = BTCSignatureHashTypeAll;
			[signatureForScript appendBytes:&hashtype length:1];
			[sigScript appendData:signatureForScript];
			[sigScript appendData:key.publicKey];

			NSAssert([key isValidSignature:signature hash:hash], @"Signature must be valid");
			txin.signatureScript = sigScript;
		}

		// Some checking code
		BTCScriptMachine *sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
		NSError *errore = nil;
		BOOL r = [sm verifyWithOutputScript:[[(BTCTransactionOutput *)txouts[0] script] copy] error:&errore];
		DLog(@"Error: %@", errore);
		NSAssert(r, @"should verify first output");

		DLog(@"Hash tx: %@", tx.transactionID);

		completion (TransactionManagerErrorTypeNone, tx);
		return;
	}

	if (unspentOutputs.count > 1) {
		completion (TransactionManagerErrorTypeNotEnoughMoney, nil);
	} else {
		completion (TransactionManagerErrorTypeNotEnoughMoneyOnAddress, nil);
	}
}

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
							  andHandler:(void (^)(TransactionManagerErrorType errorType, BTCTransaction *transaction)) completion {

	NSArray *utxos = unspentOutputs;
	if (utxos.count > 0) {

		// Find enough outputs to spend the total amount and FEE.
		BTCAmount totalAmount = amount + fee;

		// Sort utxo in order of
		utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput *obj1, BTCTransactionOutput *obj2) {
			if (obj1.value > obj2.value) {
				return NSOrderedAscending;
			} else {
				return NSOrderedDescending;
			}
		}];

		NSMutableArray *txouts = [[NSMutableArray alloc] init];
		NSInteger total = 0;

		for (BTCTransactionOutput *txout in utxos) {
			if ([txout.script isPayToPublicKeyHashScript]) {
				[txouts addObject:txout];
				total += txout.value;
			}
			if (total >= (totalAmount)) {
				break;
			}
		}

		if (total < totalAmount) {

			if (unspentOutputs.count > 1) {
				completion (TransactionManagerErrorTypeNotEnoughMoney, nil);
			} else {
				completion (TransactionManagerErrorTypeNotEnoughMoneyOnAddress, nil);
			}
			return;
		}

		// Create a new transaction
		BTCTransaction *tx = [[BTCTransaction alloc] init];
		tx.fee = fee;
		BTCAmount spentCoins = 0;

		// Add all outputs as inputs
		for (BTCTransactionOutput *txout in txouts) {
			BTCTransactionInput *txin = [[BTCTransactionInput alloc] init];
			txin.previousHash = txout.transactionHash;
			txin.previousIndex = txout.index;
			txin.runTimeAddress = txout.runTimeAddress;
			[tx addInput:txin];
			spentCoins += txout.value;
		}

		// Add required outputs - payment and change
		BTCAmount amount = 0;
		BTCTransactionOutput *paymentOutput;
		paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount script:[self.scriptBuilder sendContractScriptWithBiteCode:bitcode andContractAddress:contractAddress andGasLimit:gasLimit andGasPrice:gasPrice]];
		[tx addOutput:paymentOutput];

		BTCAddress *changeAddress = [BTCAddress addressWithString:fromAddresses.firstObject];
		BTCTransactionOutput *changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - totalAmount) address:changeAddress];

		if (changeOutput.value > 0) {
			[tx addOutput:changeOutput];
		}

		// Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
		for (int i = 0; i < txouts.count; i++) {
			// Normally, we have to find proper keys to sign this txin, but in this
			// example we already know that we use a single private key.

			BTCTransactionOutput *txout = txouts[i];
			BTCTransactionInput *txin = tx.inputs[i];
			BTCScript *sigScript = [[BTCScript alloc] init];
			NSData *d1 = tx.data;
			NSData *hash = [tx signatureHashForScript:txout.script inputIndex:i hashType:BTCSignatureHashTypeAll error:nil];
			DLog(@"Hash Sig: %@", BTCIDFromHash (hash));
			NSData *d2 = tx.data;

			NSAssert([d1 isEqual:d2], @"Transaction must not change within signatureHashForScript!");

			if (!hash) {
				completion (TransactionManagerErrorTypeOups, nil);
				return;
			}

			BTCKey *key;
			for (BTCKey *someKey in walletKeys) {
				NSString *keyString = someKey.address.string;
				if ([keyString isEqualToString:txout.script.standardAddress.string]) {
					key = someKey;
					break;
				}
			}
			if (!key) {
				completion (TransactionManagerErrorTypeOups, nil);
				return;
			}

			NSData *signature = [key signatureForHash:hash];

			NSMutableData *signatureForScript = [signature mutableCopy];
			unsigned char hashtype = BTCSignatureHashTypeAll;
			[signatureForScript appendBytes:&hashtype length:1];
			[sigScript appendData:signatureForScript];
			[sigScript appendData:key.publicKey];

			NSAssert([key isValidSignature:signature hash:hash], @"Signature must be valid");
			txin.signatureScript = sigScript;
		}

		// Some checking code
		BTCScriptMachine *sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
		NSError *errore = nil;
		BOOL r = [sm verifyWithOutputScript:[[(BTCTransactionOutput *)txouts[0] script] copy] error:&errore];
		DLog(@"Error: %@", errore);
		NSAssert(r, @"should verify first output");

		DLog(@"Hash tx: %@", tx.transactionID);
		completion (TransactionManagerErrorTypeNone, tx);
		return;
	}

	if (unspentOutputs.count > 1) {
		completion (TransactionManagerErrorTypeNotEnoughMoney, nil);
	} else {
		completion (TransactionManagerErrorTypeNotEnoughMoneyOnAddress, nil);
	}
}

- (BTCTransaction *)smartContractCreationTxWithUnspentOutputs:(NSArray *) unspentOutputs
												   withAmount:(NSInteger) amount
												  withBitcode:(NSData *) bitcode
													  withFee:(NSInteger) fee
												 withGasLimit:(QTUMBigNumber *) gasLimit
												 withGasprice:(QTUMBigNumber *) gasPrice
											   withWalletKeys:(NSArray<BTCKey *> *) walletKeys {

	NSArray *utxos = unspentOutputs;
	if (utxos.count > 0) {

		// Find enough outputs to spend the total amount and FEE.
		BTCAmount totalAmount = amount + fee;

		// Sort utxo in order of
		utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput *obj1, BTCTransactionOutput *obj2) {
			if (obj1.value > obj2.value) {
				return NSOrderedAscending;
			} else {
				return NSOrderedDescending;
			}
		}];

		NSMutableArray *txouts = [[NSMutableArray alloc] init];
		NSInteger total = 0;

		for (BTCTransactionOutput *txout in utxos) {
			if ([txout.script isPayToPublicKeyHashScript]) {
				[txouts addObject:txout];
				total += txout.value;
			}
			if (total >= (totalAmount)) {
				break;
			}
		}

		if (total < totalAmount) {
			return nil;
		}

		// Create a new transaction
		BTCTransaction *tx = [[BTCTransaction alloc] init];
		tx.fee = fee;
		BTCAmount spentCoins = 0;

		// Add all outputs as inputs
		for (BTCTransactionOutput *txout in txouts) {
			BTCTransactionInput *txin = [[BTCTransactionInput alloc] init];
			txin.previousHash = txout.transactionHash;
			txin.previousIndex = txout.index;
			txin.runTimeAddress = txout.runTimeAddress;
			[tx addInput:txin];
			spentCoins += txout.value;
		}

		// Add required outputs - payment and change
		BTCAmount amount = 0;
		BTCTransactionOutput *paymentOutput;
		paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount script:[self.scriptBuilder createContractScriptWithBiteCode:bitcode andGasLimit:gasLimit andGasPrice:gasPrice]];
		[tx addOutput:paymentOutput];

		BTCAddress *changeAddress = SLocator.appSettings.isMainNet ? walletKeys.firstObject.address : walletKeys.firstObject.addressTestnet;
		BTCTransactionOutput *changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - totalAmount) address:changeAddress];

		if (changeOutput.value > 0) {
			[tx addOutput:changeOutput];
		}

		// Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
		for (int i = 0; i < txouts.count; i++) {
			// Normally, we have to find proper keys to sign this txin, but in this
			// example we already know that we use a single private key.

			BTCTransactionOutput *txout = txouts[i];
			BTCTransactionInput *txin = tx.inputs[i];
			BTCScript *sigScript = [[BTCScript alloc] init];
			NSData *d1 = tx.data;
			NSData *hash = [tx signatureHashForScript:txout.script inputIndex:i hashType:BTCSignatureHashTypeAll error:nil];
			DLog(@"Hash Sig: %@", BTCIDFromHash (hash));
			NSData *d2 = tx.data;

			NSAssert([d1 isEqual:d2], @"Transaction must not change within signatureHashForScript!");

			if (!hash) {
				return nil;
			}

			BTCKey *key;
			for (BTCKey *someKey in walletKeys) {
				NSString *keyString = someKey.address.string;// SLocator.appSettings.isMainNet ? someKey.address.string : someKey.addressTestnet.string;
				if ([keyString isEqualToString:txout.script.standardAddress.string]) {
					key = someKey;
					break;
				}
			}
			if (!key) {
				return nil;
			}

			NSData *signature = [key signatureForHash:hash];

			NSMutableData *signatureForScript = [signature mutableCopy];
			unsigned char hashtype = BTCSignatureHashTypeAll;
			[signatureForScript appendBytes:&hashtype length:1];
			[sigScript appendData:signatureForScript];
			[sigScript appendData:key.publicKey];

			NSAssert([key isValidSignature:signature hash:hash], @"Signature must be valid");
			txin.signatureScript = sigScript;
		}

		return tx;
	}

	return nil;
}

@end
