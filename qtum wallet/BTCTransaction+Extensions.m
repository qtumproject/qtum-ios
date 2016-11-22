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
        
        BOOL didHexMethodPrepare = class_addMethod(class, originalSelectorPrepare,
                                                   method_getImplementation(swizzledMethodPrepare),
                                                   method_getTypeEncoding(swizzledMethodPrepare));
        
        BOOL didDictionaryMethodPrepare = class_addMethod(class, originalDictionarySelectorPrepare,
                                                   method_getImplementation(swizzledDictionaryMethodPrepare),
                                                   method_getTypeEncoding(swizzledDictionaryMethodPrepare));
        
        BOOL didCopyMethodPrepare = class_addMethod(class, originalCopySelectorPrepare,
                                                          method_getImplementation(swizzledCopyMethodPrepare),
                                                          method_getTypeEncoding(swizzledCopyMethodPrepare));
        
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

@end
