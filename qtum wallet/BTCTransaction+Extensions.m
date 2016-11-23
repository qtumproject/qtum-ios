//
//  BTCTransaction+Extensions.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 22.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "BTCTransaction+Extensions.h"
#import <objc/runtime.h>

@implementation BTCTransaction (Extensions)

- (uint32_t)time
{
    uint32_t numberTime = (uint32_t)[objc_getAssociatedObject(self, @selector(time)) unsignedIntegerValue];
    return numberTime;
}

- (void)setTime:(uint32_t)time
{
    objc_setAssociatedObject(self,
                             @selector(time),
                             @(time),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        //
        
        SEL originalSelectorPrepare = @selector(data);
        SEL swizzledSelectorPrepare = @selector(mineData);
        
        Method originalMethodPrepare = class_getInstanceMethod(class, originalSelectorPrepare);
        Method swizzledMethodPrepare = class_getInstanceMethod(class, swizzledSelectorPrepare);
        
        //
        
        SEL originalDictionarySelectorPrepare = @selector(dictionary);
        SEL swizzledDictionarySelectorPrepare = @selector(mineDictionary);
        
        Method originalDictionaryMethodPrepare = class_getInstanceMethod(class, originalDictionarySelectorPrepare);
        Method swizzledDictionaryMethodPrepare = class_getInstanceMethod(class, swizzledDictionarySelectorPrepare);
        
        //
        
        SEL originalCopySelectorPrepare = @selector(copy);
        SEL swizzledCopySelectorPrepare = @selector(mineCopy);
        
        Method originalCopyMethodPrepare = class_getInstanceMethod(class, originalCopySelectorPrepare);
        Method swizzledCopyMethodPrepare = class_getInstanceMethod(class, swizzledCopySelectorPrepare);

        //
        
        SEL originalSignatureSelectorPrepare = @selector(signatureHashForScript:inputIndex:hashType:error:);
        SEL swizzledSignatureSelectorPrepare = @selector(mineSignatureHashForScript:inputIndex:hashType:error:);
        
        Method originalSignatureMethodPrepare = class_getInstanceMethod(class, originalSignatureSelectorPrepare);
        Method swizzledSignatureMethodPrepare = class_getInstanceMethod(class, swizzledSignatureSelectorPrepare);
        
        //
        
        BOOL didHexMethodPrepare = class_addMethod(class, originalSelectorPrepare,
                                                   method_getImplementation(swizzledMethodPrepare),
                                                   method_getTypeEncoding(swizzledMethodPrepare));
        
        BOOL didDictionaryMethodPrepare = class_addMethod(class, originalDictionarySelectorPrepare,
                                                   method_getImplementation(swizzledDictionaryMethodPrepare),
                                                   method_getTypeEncoding(swizzledDictionaryMethodPrepare));
        
        BOOL didCopyMethodPrepare = class_addMethod(class, originalCopySelectorPrepare,
                                                          method_getImplementation(swizzledCopyMethodPrepare),
                                                          method_getTypeEncoding(swizzledCopyMethodPrepare));
        
        BOOL didSignatureMethodPrepare = class_addMethod(class, originalSignatureSelectorPrepare,
                                                    method_getImplementation(swizzledSignatureMethodPrepare),
                                                    method_getTypeEncoding(swizzledSignatureMethodPrepare));
        
        //
        
        if (didHexMethodPrepare) {
            class_replaceMethod(class,
                                swizzledSelectorPrepare,
                                method_getImplementation(originalMethodPrepare),
                                method_getTypeEncoding(originalMethodPrepare));
        } else {
            method_exchangeImplementations(originalMethodPrepare, swizzledMethodPrepare);
        }
        
        if (didDictionaryMethodPrepare) {
            class_replaceMethod(class,
                                swizzledDictionarySelectorPrepare,
                                method_getImplementation(originalDictionaryMethodPrepare),
                                method_getTypeEncoding(originalDictionaryMethodPrepare));
        } else {
            method_exchangeImplementations(originalDictionaryMethodPrepare, swizzledDictionaryMethodPrepare);
        }
        
        if (didCopyMethodPrepare) {
            class_replaceMethod(class,
                                swizzledCopySelectorPrepare,
                                method_getImplementation(originalCopyMethodPrepare),
                                method_getTypeEncoding(originalCopyMethodPrepare));
        } else {
            method_exchangeImplementations(originalCopyMethodPrepare, swizzledCopyMethodPrepare);
        }
        
        if (didSignatureMethodPrepare) {
            class_replaceMethod(class,
                                swizzledSignatureSelectorPrepare,
                                method_getImplementation(originalSignatureMethodPrepare),
                                method_getTypeEncoding(originalSignatureMethodPrepare));
        } else {
            method_exchangeImplementations(originalSignatureMethodPrepare, swizzledSignatureMethodPrepare);
        }
    });
}

- (NSData *)mineData
{
    return [self computeMinePayload];
}

- (NSData *)computeMinePayload
{
    NSMutableData* payload = [NSMutableData data];
    
    // 4-byte version
    uint32_t ver = self.version;
    [payload appendBytes:&ver length:4];
    
    // varint with number of inputs
    [payload appendData:[BTCProtocolSerialization dataForVarInt:self.inputs.count]];
    
    // input payloads
    for (BTCTransactionInput* input in self.inputs) {
        [payload appendData:input.data];
    }
    
    // varint with number of outputs
    [payload appendData:[BTCProtocolSerialization dataForVarInt:self.outputs.count]];
    
    // output payloads
    for (BTCTransactionOutput* output in self.outputs) {
        [payload appendData:output.data];
    }
    
    // 4-byte lock_time
    uint32_t lt = self.lockTime;
    [payload appendBytes:&lt length:4];
    
    // 4-byte time
    uint32_t time = self.time;
    [payload appendBytes:&time length:4];
    
    return payload;
}

- (NSData *)computePayloadForSignature
{
    NSMutableData* payload = [NSMutableData data];
    
    // 4-byte version
    uint32_t ver = self.version;
    [payload appendBytes:&ver length:4];
    
    // varint with number of inputs
    [payload appendData:[BTCProtocolSerialization dataForVarInt:self.inputs.count]];
    
    // input payloads
    for (BTCTransactionInput* input in self.inputs) {
        [payload appendData:input.data];
    }
    
    // varint with number of outputs
    [payload appendData:[BTCProtocolSerialization dataForVarInt:self.outputs.count]];
    
    // output payloads
    for (BTCTransactionOutput* output in self.outputs) {
        [payload appendData:output.data];
    }
    
    // 4-byte lock_time
    uint32_t lt = self.lockTime;
    [payload appendBytes:&lt length:4];
    
    return payload;
}

- (NSDictionary *)mineDictionary
{
    return @{
             @"hash":      self.transactionID,
             @"ver":       @(self.version),
             @"vin_sz":    @(self.inputs.count),
             @"vout_sz":   @(self.outputs.count),
             @"lock_time": @(self.lockTime),
             @"size":      @(self.data.length),
             @"in":        [self.inputs valueForKey:@"dictionary"],
             @"out":       [self.outputs valueForKey:@"dictionary"],
             @"time":      @(self.time)
             };
}

- (id)mineCopy
{
    BTCTransaction *tx = [self mineCopy];
    tx.time = self.time;
    return tx;
}

- (NSData*)mineSignatureHashForScript:(BTCScript*)subscript inputIndex:(uint32_t)inputIndex hashType:(BTCSignatureHashType)hashType error:(NSError**)errorOut {
    // Create a temporary copy of the transaction to apply modifications to it.
    BTCTransaction* tx = [self copy];
    
    // We may have a scriptmachine instantiated without a transaction (for testing),
    // but it should not use signature checks then.
    if (!tx || inputIndex == 0xFFFFFFFF) {
        if (errorOut) *errorOut = [NSError errorWithDomain:BTCErrorDomain
                                                      code:BTCErrorScriptError
                                                  userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Transaction and valid input index must be provided for signature verification.", @"")}];
        return nil;
    }
    
    // Note: BitcoinQT returns a 256-bit little-endian number 1 in such case, but it does not matter
    // because it would crash before that in CScriptCheck::operator()(). We normally won't enter this condition
    // if script machine is instantiated with initWithTransaction:inputIndex:, but if it was just -init-ed, it's better to check.
    if (inputIndex >= tx.inputs.count) {
        if (errorOut) *errorOut = [NSError errorWithDomain:BTCErrorDomain
                                                      code:BTCErrorScriptError
                                                  userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:
                                                                                        NSLocalizedString(@"Input index is out of bounds for transaction: %d >= %d.", @""),
                                                                                        (int)inputIndex, (int)tx.inputs.count]}];
        return nil;
    }
    
    // In case concatenating two scripts ends up with two codeseparators,
    // or an extra one at the end, this prevents all those possible incompatibilities.
    // Note: this normally never happens because there is no use for OP_CODESEPARATOR.
    // But we have to do that cleanup anyway to not break on rare transaction that use that for lulz.
    // Also: we modify the same subscript which is used several times for multisig check, but that's what BitcoinQT does as well.
    [subscript deleteOccurrencesOfOpcode:OP_CODESEPARATOR];
    
    // Blank out other inputs' signature scripts
    // and replace our input script with a subscript (which is typically a full output script from the previous transaction).
    for (BTCTransactionInput* txin in tx.inputs) {
        txin.signatureScript = [[BTCScript alloc] init];
    }
    ((BTCTransactionInput*)tx.inputs[inputIndex]).signatureScript = subscript;
    
    // Blank out some of the outputs depending on BTCSignatureHashType
    // Default is SIGHASH_ALL - all inputs and outputs are signed.
    if ((hashType & SIGHASH_OUTPUT_MASK) == SIGHASH_NONE) {
        // Wildcard payee - we can pay anywhere.
        [tx removeAllOutputs];
        
        // Blank out others' input sequence numbers to let others update transaction at will.
        for (NSUInteger i = 0; i < tx.inputs.count; i++) {
            if (i != inputIndex) {
                ((BTCTransactionInput*)tx.inputs[i]).sequence = 0;
            }
        }
    } else if ((hashType & SIGHASH_OUTPUT_MASK) == SIGHASH_SINGLE) {
        // Single mode assumes we sign an output at the same index as an input.
        // Outputs before the one we need are blanked out. All outputs after are simply removed.
        // Only lock-in the txout payee at same index as txin.
        uint32_t outputIndex = inputIndex;
        
        // If outputIndex is out of bounds, BitcoinQT is returning a 256-bit little-endian 0x01 instead of failing with error.
        // We should do the same to stay compatible.
        if (outputIndex >= tx.outputs.count) {
            static unsigned char littleEndianOne[32] = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
            return [NSData dataWithBytes:littleEndianOne length:32];
        }
        
        // All outputs before the one we need are blanked out. All outputs after are simply removed.
        // This is equivalent to replacing outputs with (i-1) empty outputs and a i-th original one.
        BTCTransactionOutput* myOutput = tx.outputs[outputIndex];
        [tx removeAllOutputs];
        for (int i = 0; i < outputIndex; i++) {
            [tx addOutput:[[BTCTransactionOutput alloc] init]];
        }
        [tx addOutput:myOutput];
        
        // Blank out others' input sequence numbers to let others update transaction at will.
        for (NSUInteger i = 0; i < tx.inputs.count; i++) {
            if (i != inputIndex) {
                ((BTCTransactionInput*)tx.inputs[i]).sequence = 0;
            }
        }
    }
    
    // Blank out other inputs completely. This is not recommended for open transactions.
    if (hashType & SIGHASH_ANYONECANPAY) {
        BTCTransactionInput* input = tx.inputs[inputIndex];
        [tx removeAllInputs];
        [tx addInput:input];
    }
    
    // Important: we have to hash transaction together with its hash type.
    // Hash type is appended as little endian uint32 unlike 1-byte suffix of the signature.
    NSMutableData* fulldata = [[self computePayloadForSignature] mutableCopy];
    uint32_t hashType32 = OSSwapHostToLittleInt32((uint32_t)hashType);
    [fulldata appendBytes:&hashType32 length:sizeof(hashType32)];
    
    NSData* hash = BTCHash256(fulldata);
    
    //    NSLog(@"\n----------------------\n");
    //    NSLog(@"TX: %@", BTCHexFromData(fulldata));
    //    NSLog(@"TX SUBSCRIPT: %@ (%@)", BTCHexFromData(subscript.data), subscript);
    //    NSLog(@"TX HASH: %@", BTCHexFromData(hash));
    //    NSLog(@"TX PLIST: %@", tx.dictionary);
    
    return hash;
}

@end
