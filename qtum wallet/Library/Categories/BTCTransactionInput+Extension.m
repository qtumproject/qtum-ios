//
//  BTCTransactionInput+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BTCTransactionInput+Extension.h"
#import <objc/runtime.h>

NSString const *keyIn = @"com.qtum.input.extension";

@implementation BTCTransactionInput (Extension)

- (void)setRunTimeAddress:(NSString *)runTimeAddress {
    
    objc_setAssociatedObject(self, &keyIn, runTimeAddress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)runTimeAddress {
    
    return objc_getAssociatedObject(self, &keyIn);
}

@end
