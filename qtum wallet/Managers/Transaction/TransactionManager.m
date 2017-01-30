//
//  TransactionManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 02.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "TransactionManager.h"
#import "RequestManager.h"
#import "RPCRequestManager.h"
#import "BlockchainInfoManager.h"

static double FEE = 10000;

@interface TransactionManager ()

// Array of current keys for sending
@property (nonatomic) NSArray *keys;

 /*Array with dictionaries with amounts and addreses for send
  @{@"amount" : @"amount", @"address" : @"BTCPublicKeyAddressTestnet"}*/
@property (nonatomic) NSArray *amountsAndAddresses;

// Total amount for all addresses
@property (nonatomic) BTCAmount totalAmount;

@end

@implementation TransactionManager

- (instancetype) initWith:(NSArray *)amountsAndAddresses
{
    self = [super init];
    if (self) {
        self.keys = [[WalletManager sharedInstance] getCurrentWallet].getAllKeys;
        [self createAmountsAndAddresses:amountsAndAddresses];
    }
    return self;
}

- (void)sendTransactionWithSuccess:(void(^)())success andFailure:(void(^)(NSString *message))failure
{
    if (!self.amountsAndAddresses || self.amountsAndAddresses.count == 0) {
        failure(@"Enter valid arress");
        return;
    }
    
    NSError *error;
    [self transaction:&error success:^(BTCTransaction *tx) {
        if (tx) {
            [[RPCRequestManager sharedInstance] sendTransaction:tx.hexWithTime withSuccessHandler:^(id responseObject) {
                success();
            } andFailureHandler:^(NSError *error, NSString *message) {
                failure(@"Can not send transaction");
            }];
        }else{
            failure(@"Can not create transaction");
        }
    } andFailure:^(NSString *message){
        failure(message);
    }];
}

#pragma mark - Transaction

- (void)transaction:(NSError**)errorOut
                                  success:(void(^)(BTCTransaction *tx))success
                               andFailure:(void(^)(NSString *message))failure
{
    if (!self.keys || self.keys.count == 0) {
        failure(@"My public key not valid");
    }
    
    NSMutableArray *addresesForSending = [NSMutableArray new];
    for (BTCKey *key in self.keys) {
        [addresesForSending addObject:key.addressTestnet.string];
    }
    if (addresesForSending.count == 0) {
        failure(@"Public key not valid");
        return;
    }
    
    [BlockchainInfoManager getunspentOutputs:addresesForSending withSuccessHandler:^(NSArray *responseObject) {
        BTCTransaction *tx = [self transaction:errorOut unspentOutputs:responseObject];
        success(tx);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(@"Can not get balance");
    }];
}


- (BTCTransaction *)transaction:(NSError**)errorOut
                 unspentOutputs:(NSArray *)unspentOutputs
{
    NSError *error = nil;
    NSArray *utxos = unspentOutputs;
    if (!utxos || utxos.count == 0) {
        *errorOut = error;
        return nil;
    }
    
    // Find enough outputs to spend the total amount.
    BTCAmount totalAmount = self.totalAmount + FEE;
    
    // Sort utxo in order of
    utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput* obj1, BTCTransactionOutput* obj2) {
        if ((obj1.value - obj2.value) < 0) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    
    NSMutableArray* txouts = [[NSMutableArray alloc] init];
    long total = 0;
    
    for (BTCTransactionOutput* txout in utxos) {
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
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    for (BTCTransactionOutput* txout in txouts) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        txin.previousHash = txout.transactionHash;
        txin.previousIndex = txout.index;
        [tx addInput:txin];
        spentCoins += txout.value;
    }
    
    // Add required outputs - payment and change
    for (NSDictionary *dictionary in self.amountsAndAddresses) {
        BTCPublicKeyAddress *toPublicKeyAddress = dictionary[@"address"];
        BTCAmount amount = [dictionary[@"amount"] longLongValue];
        
        BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount address:toPublicKeyAddress];
        [tx addOutput:paymentOutput];
    }
    
    BTCKey *firstKey = [self.keys firstObject];
    BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - (totalAmount + FEE)) address:firstKey.address];
    
    if (changeOutput.value > 0) {
        [tx addOutput:changeOutput];
    }
    
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
    for (int i = 0; i < txouts.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this
        // example we already know that we use a single private key.
        
        BTCTransactionOutput* txout = txouts[i];
        BTCTransactionInput* txin = tx.inputs[i];
        BTCScript* sigScript = [[BTCScript alloc] init];
        NSData* d1 = tx.data;
        NSData* hash = [tx signatureHashForScript:txout.script inputIndex:i hashType:BTCSignatureHashTypeAll error:errorOut];
        NSLog(@"Hash Sig: %@", BTCIDFromHash(hash));
        NSData* d2 = tx.data;
        
        NSAssert([d1 isEqual:d2], @"Transaction must not change within signatureHashForScript!");
        
        if (!hash) {
            return nil;
        }
        
        BTCKey *key;
        for (BTCKey *someKey in self.keys) {
            if ([someKey.address.string isEqualToString:txout.script.standardAddress.string]) {
                key = someKey;
                break;
            }
        }
        if (!key) {
            return nil;
        }
        
        NSData* signature = [key signatureForHash:hash];
        
        NSMutableData* signatureForScript = [signature mutableCopy];
        unsigned char hashtype = BTCSignatureHashTypeAll;
        [signatureForScript appendBytes:&hashtype length:1];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:key.publicKey];
        
        NSAssert([key isValidSignature:signature hash:hash], @"Signature must be valid");
        txin.signatureScript = sigScript;
    }
    
    // Some checking code
    BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
    NSError* errore = nil;
    BOOL r = [sm verifyWithOutputScript:[[(BTCTransactionOutput*)txouts[0] script] copy] error:&errore];
    NSLog(@"Error: %@", errore);
    NSAssert(r, @"should verify first output");
    
    NSLog(@"Hash tx: %@", tx.transactionID);
    return tx;
}

#pragma mark -

- (void)createAmountsAndAddresses:(NSArray *)array
{
    NSMutableArray *mutArray = [NSMutableArray new];
    for (NSDictionary *dictionary in array) {
        BTCPublicKeyAddress *toPublicKeyAddress = [BTCPublicKeyAddress addressWithString:dictionary[@"address"]];
        BTCAmount amount = [BlockchainInfoManager convertValueToAmount:[dictionary[@"amount"] doubleValue]];
        
        self.totalAmount += amount;
        
        if (!toPublicKeyAddress) {
            self.amountsAndAddresses = nil;
            return;
        }
        
        NSDictionary *newDictionary = @{@"address" : toPublicKeyAddress, @"amount" : @(amount)};
        [mutArray addObject:newDictionary];
    }
    
    self.amountsAndAddresses = [NSArray arrayWithArray:mutArray];
}

//
- (NSString *)hexadecimalString:(NSData *)data
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end









