//
//  BTCTransactionOutput+Address.m
//  qtum wallet
//
//  Created by Никита Федоренко on 17.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BTCTransactionOutput+Address.h"
#import <objc/runtime.h>

NSString const *keyOut = @"com.pixelplex.output.extension";

@implementation BTCTransactionOutput (Address)

- (void)setRunTimeAddress:(NSString *)runTimeAddress {
    
    objc_setAssociatedObject(self, &keyOut, runTimeAddress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)runTimeAddress {
    
    return objc_getAssociatedObject(self, &keyOut);
}

@end
